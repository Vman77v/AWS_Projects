data "aws_iam_policy_document" "secretmanager_kms" {
  statement {
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.caller_identity.account_id}:root"]
      type = "AWS"
    }

    actions = ["kms:*"]
    resources = ["*"]
  }

  statement {
    principals {
      identifiers = ["*"]
      type = "AWS"
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    condition {
      test = "StringEquals"
      values = ["secretsmanager.${var.aws_region}.amazonaws.com"]
      variable = "kms:ViaService"
    }

    condition {
      test = "StringEquals"
      values = [data.aws_caller_identity.caller_identity.account_id]
      variable = "kms:CallerAccount"
    }
  }
}

data "aws_kms_key" "managed_kms_key" {
  key_id = "alias/aws/secretsmanager"
}
