resource "aws_iam_user" "k8s" {
  name = "k8s"
  path = "/"
  tags = merge({ Name = "k8s" }, local.dev-tags)
}

module "iam_groups" {
  source = "../../modules/iam/"
  admins = [
    aws_iam_user.k8s.name,
  ]
}
