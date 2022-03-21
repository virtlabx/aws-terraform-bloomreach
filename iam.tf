resource "aws_iam_user" "k8s-user" {
  name = "k8s-user"
  path = "/"
  tags = merge({ Name = "k8s-user" }, local.dev-tags)
}

module "iam_groups" {
  source = "./modules/iam"
  admins = [
    aws_iam_user.k8s-user.name,
  ]
}

resource "aws_iam_account_password_policy" "default" {
  minimum_password_length        = 12
  password_reuse_prevention      = 24
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 30
}

resource "aws_iam_role" "cloudwatch-agent-role" {
  name               = "CloudWatchAgentServerRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [ {
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  } ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch-agent-role-policy-attachment" {
  role       = aws_iam_role.cloudwatch-agent-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cloudwatch-agent-instance-profile" {
  name = "cloudwatch-agent-instance-profile"
  role = aws_iam_role.cloudwatch-agent-role.name
}