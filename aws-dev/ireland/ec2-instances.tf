module "jenkins-master" {
  source                      = "../../modules/ec2/"
  tags                        = local.dev-tags
  instance_hostname           = "jenkins-dev-master"
  instance_subnet_id          = module.eks-vpc.public_subnets[0]
  instance_security_group_ids = [aws_security_group.bloomreach-jenkins-dev-sg.id]
  instance_type               = "t3a.medium"
  iam_instance_profile        = aws_iam_instance_profile.cloudwatch-agent-instance-profile.name
  instance_ami                = "ami-0069d66985b09d219"
  record_zone_id              = aws_route53_zone.bloomreach.zone_id
  ssh_user                    = "jenkins"
  ssh_authorized_keys         = aws_key_pair.bloomreach-jenkins-dev.public_key
}