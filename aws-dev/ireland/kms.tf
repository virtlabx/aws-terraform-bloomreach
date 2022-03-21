resource "aws_iam_service_linked_role" "autoscaling-role" {
  aws_service_name = "autoscaling.amazonaws.com"
  tags             = merge({ Name = "eks-autoscaling-role" }, local.dev-tags)
}

resource "aws_kms_key" "kms_key" {
  description             = "A KMS key to encrypt EKS cluster config."
  deletion_window_in_days = "30"
  enable_key_rotation     = "true"
  policy                  = data.aws_iam_policy_document.kms_policy.json
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid       = "AllowAWSRootAccount"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid       = "Allow service-linked role use of the CMK"
    resources = ["*"]
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling_myenv",
        module.eks-cluster.cluster_iam_role_arn,
      ]
    }
  }
  statement {
    sid       = "Allow attachment of persistent resources"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling_myenv", # required for the ASG to manage encrypted volumes for nodes
        module.eks-cluster.cluster_iam_role_arn,                                                                                                            # required for the cluster / persistentvolume-controller to create encrypted PVCs
      ]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}