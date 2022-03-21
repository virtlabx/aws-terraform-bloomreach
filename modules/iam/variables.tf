variable "admins" {
  description = "List of the names of admins"
  type        = list
  default     = []
}

locals {
  default-policies = [
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    aws_iam_policy.mfa-policy.arn,
  ]
}