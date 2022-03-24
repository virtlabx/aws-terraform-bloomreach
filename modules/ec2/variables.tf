variable "tags" {
  description = "tags for dev-server module"
  type        = map
}

variable "instance_hostname" {
  description = "The ec2 instance hostname"
  type        = string
}

variable "instance_security_group_ids" {
  description = "List of the security groups"
  type        = list
}

variable "public_ip" {
  description = "Sets associate_public_ip_address to true or false"
  default     = true
}

variable "instance_volume_size" {
  description = "The size of the EBS volume"
  type        = number
  default     = 50
}

variable "ssh_authorized_keys" {
  description = "SSH key of the main user"
}

variable "ssh_user" {
  description = "Username of the main ec2 instance user"
  default     = "ec2-user"
}

variable "instance_subnet_id" {
  description = "The subnet id to create server in"
}

variable "instance_ami" {
  description = "The AMI to base server on"
}

variable "instance_type" {
  description = "Instance type of the server"
  default     = "t3a.micro"
}

variable "docker_install" {
  description = "Docker install"
  type        = bool
  default     = true
}

variable "jenkins_install" {
  description = "Jenkins server install"
  type        = bool
  default     = true
}

variable "vault_install" {
  description = "Vault install"
  type        = bool
  default     = true
}

variable "cloudwatch_install" {
  description = "cloudwatch agent install"
  type        = bool
  default     = true
}

variable "instance_name_format" {
  description = "The name format to be used as hostname and tag"
  type        = string
  default     = "bloomreach-%03d"
}

variable "instance_count" {
  description = "The number of instances"
  type        = number
  default     = 1
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
}

variable "associate_eip" {
  description = "Associate EIP to the ec2 instance"
  type        = bool
  default     = true
}

locals {
  ips = aws_instance.server.*.private_ip
  cidr_blocks = [ for ip in local.ips : "${ip}/32" ]
}