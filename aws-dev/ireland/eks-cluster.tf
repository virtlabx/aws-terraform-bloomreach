module "eks-cluster"{
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = local.cluster_name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = module.eks-vpc.vpc_id
  subnet_ids                      = concat(module.eks-vpc.private_subnets, module.eks-vpc.public_subnets)
  tags                            = merge({ Name = "${local.cluster_name}" }, local.dev-tags)
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
    cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.kms_key.arn
    resources        = ["secrets"]
  }]
  self_managed_node_group_defaults = {
    instance_type                          = "m6i.large"
    update_launch_template_default_version = true
    iam_role_additional_policies           = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  }
  self_managed_node_groups = {
    one = {
      name = "spot-1"
      public_ip    = true
      max_size     = 4
      desired_size = 2
      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }
        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }
      pre_bootstrap_user_data = <<-EOT
      echo "Hello"
      export Hello=Bloomreach
      EOT
      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
      post_bootstrap_user_data = <<-EOT
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOT
    }
  }
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }
  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      labels = merge({ Name = "${local.cluster_name}" }, local.dev-tags)
      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
      tags = merge({ Name = "${local.cluster_name}" }, local.dev-tags)
    }
  }
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
        }
      ]

      tags = merge({ Name = "${local.cluster_name}" }, local.dev-tags)
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }
}