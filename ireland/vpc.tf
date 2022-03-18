module "eks-vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "${local.cluster_name}-vpc"
  cidr                 = "172.21.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.21.1.0/26", "172.21.1.64/26", "172.21.1.128/26"]
  public_subnets       = ["172.21.0.0/26", "172.21.0.64/26", "172.21.0.128/26"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags                 = merge({ Name = "${local.cluster_name}-vpc" }, local.dev-tags)
  public_subnet_tags   = merge({ Name = "${local.cluster_name}-public-subnet" }, local.dev-tags)
  private_subnet_tags  = merge({ Name = "${local.cluster_name}-private-subnet" }, local.dev-tags)
}