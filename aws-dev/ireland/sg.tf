resource "aws_security_group" "bloomreach-jenkins-dev-sg" {
  name        = "bloomreach-jenkins-dev-sg"
  description = "SG for jenkins EC2 instance."
  vpc_id      = module.eks-vpc.vpc_id
  tags        = merge({Name = "bloomreach-jenkins-dev-sg" }, module.tagging.dev-tags)
  ingress {
    description     = "Allow all traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"] # TODO harden this sg inbound rule
  }
  egress {
    description     = "Allow all traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"] # TODO harden this sg outbound rule
  }
}