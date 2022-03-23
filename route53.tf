resource "aws_route53_zone" "bloomreach" {
  name = "jenkins-vault-bloomreach.com"
  tags = local.dev-tags
  vpc {
    vpc_id = module.eks-vpc.vpc_id
  }
}