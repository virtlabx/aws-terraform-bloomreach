resource "aws_security_group" "bloomreach-jenkins-dev-sg" {
  name        = "bloomreach-jenkins-dev-sg"
  description = "SG for jenkins EC2 instance."
  vpc_id      = module.eks-vpc.vpc_id
  tags        = merge({Name = "bloomreach-jenkins-dev-sg" }, module.tagging.dev-tags)
  ingress {
    description     = "Allow the default jenkins port."
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  ingress {
    description     = "Allow ssh access from my IP address."
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["77.250.27.40/32"]
  }
  egress {
    description     = "Allow SMTP to send email in case of a build failures."
    from_port       = 25
    to_port         = 25
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  egress {
    description     = "Allow HTTPS to install plugins."
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
}