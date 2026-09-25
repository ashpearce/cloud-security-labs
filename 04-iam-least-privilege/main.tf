data "aws_caller_identity" "me" {}

locals {
  account_id = data.aws_caller_identity.me.account_id
}

variable "external_id" {
  description = "Shared code word required to assume the auditor role"
  type        = string
  default     = "csl-lab-2026"
}

# Trust policy: who may pick up the badge (AC-2, IA-2)
data "aws_iam_policy_document" "auditor_trust" {
  statement {
    sid     = "AllowSsoUsersWithExternalId"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${local.account_id}:role/aws-reserved/sso.amazonaws.com/*"]
    }
  }
}

resource "aws_iam_role" "auditor" {
  name                 = "csl-auditor-readonly"
  description          = "Least-privilege read-only role for security posture checks"
  assume_role_policy   = data.aws_iam_policy_document.auditor_trust.json
  max_session_duration = 3600
}

# Permissions policy: which doors the badge opens (AC-6)
resource "aws_iam_role_policy" "auditor" {
  name   = "least-privilege-read"
  role   = aws_iam_role.auditor.id
  policy = file("${path.module}/policies/auditor-readonly.json")
}

output "auditor_role_arn" {
  value = aws_iam_role.auditor.arn
}