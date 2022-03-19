resource "aws_iam_group" "admins" {
  name = "Admins"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "admins" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "default-policies" {
  count      = length(local.default-policies)
  group      = aws_iam_group.admins.name
  policy_arn = element(local.default-policies, count.index)
}

resource "aws_iam_group_membership" "admins" {
  name = "admins-membership"
  users = var.admins
  group = aws_iam_group.admins.name
}