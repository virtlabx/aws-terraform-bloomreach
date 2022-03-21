resource "aws_iam_user" "k8s-user" {
  name = "k8s-user"
  path = "/"
  tags = merge({ Name = "k8s-user" }, local.dev-tags)
}

module "iam_groups" {
  source = "../../modules/iam/"
  admins = [
    aws_iam_user.k8s-user.name,
  ]
}