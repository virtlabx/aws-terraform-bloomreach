resource "aws_security_group" "bloomreach-jenkins-dev-sg" {
  name        = "bloomreach-jenkins-dev-sg"
  description = "SG for jenkins EC2 instance."
  vpc_id      = module.eks-vpc.vpc_id
  tags        = merge({Name = "bloomreach-jenkins-dev-sg" }, module.tagging.dev-tags)
  ingress {
    description = "Allow the default jenkins port."
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["172.21.0.0/16"] # The VPC CIDR block
  }
  ingress {
    description = "Allow ssh access from my IP address."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["178.84.204.183/32"] # This is my IP
  }
  ingress {
    description = "Allow access to vault UI."
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["172.21.0.0/16"] # The VPC CIDR block
  }
  ingress {
    description = "Allow HTTPS access to the application load balancer the has jenkins EC2 instance behind."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  egress {
    description = "Allow SMTP to send email in case of a build failures."
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  egress {
    description = "Allow HTTPS to install plugins."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  egress {
    description = "Allow HTTP to install packages on the server."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  egress {
    description = "Allow the default jenkins port to receive health check response on that port."
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
  egress {
    description = "Allow access to vault UI."
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This should be limited to a specific subnet/ip.
  }
}