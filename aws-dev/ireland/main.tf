provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks-cluster-auth.token
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "eks-cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = module.eks-cluster.cluster_id
}

terraform {
  backend "s3" {
    bucket         = "bloomreach-dev-interviews-terraform-ayaelawdan"
    key            = "ireland/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "bloomreach-dev-interviews-terraform-ayaelawdan-tflocks"
    encrypt        = true
  }
}