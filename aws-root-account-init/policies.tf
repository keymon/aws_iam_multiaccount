resource "aws_iam_policy" "AssumeBillingRole" {
  name        = "AssumeBillingRole"
  description = "Allow to assume billing in current account"
  path        = "/custom/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "sts:AssumeRole"
    ],
    "Resource": [
      "arn:aws:iam::${var.root_account_id}:role/billing"
    ]
  }
}
EOF
}

resource "aws_iam_policy" "AssumeAdminRole" {
  name        = "AssumeAdminRole"
  description = "Allow to assume admin in current and sub accounts account"
  path        = "/custom/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "sts:AssumeRole"
    ],
    "Resource": ${
      jsonencode(
        formatlist(
          "arn:aws:iam::%s:role/admin",
          concat(list(var.root_account_id), var.sub_account_ids)
        )
      )
    }
  }
}
EOF
}

resource "aws_iam_policy" "AssumeSubAccountDevRole" {
  name        = "AssumeSubAccountDevRole"
  description = "Allow to assume roles in subaccounts"
  path        = "/custom/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "sts:AssumeRole"
    ],
    "Resource": ${
      jsonencode(
        formatlist(
          "arn:aws:iam::%s:role/dev",
          concat(list(var.root_account_id), var.sub_account_ids)
        )
      )
    }
  }
}
EOF
}

data "template_file" "AssumeRoleTrustPolicyRootAccountWithMFA" {
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.root_account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF

  vars {
    root_account_id = "${var.root_account_id}"
  }
}

resource "aws_iam_policy" "SelfManageAccount" {
  name        = "SelfManageAccount"
  description = "Users should be able to manage their own user, change password, update keys, MFA, etc"
  path        = "/custom/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:ListUsers",
        "iam:ListGroups",
        "iam:ListGroupPolicies",
        "iam:ListAttachedGroupPolicies",
        "iam:ListAccountAliases",
        "iam:EnableMFADevice",
        "iam:GetAccountSummary"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:List*",
        "iam:GetUser",
        "iam:ChangePassword",
        "iam:GetLoginProfile",
        "iam:*AccessKey*",
        "iam:*SSHPublicKey",
        "iam:*ServiceSpecificCredential"
      ],
      "Resource": [
        "arn:aws:iam::*:user/$${aws:username}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:ActivateMFADevice",
        "iam:CreateVirtualMFADevice",
        "iam:DeactivateMFADevice",
        "iam:DeleteVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:ResyncMFADevice",
        "iam:List*"
      ],
      "Resource": [
        "arn:aws:iam::*:user/$${aws:username}",
        "arn:aws:iam::*:mfa/$${aws:username}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:ListVirtualMFADevices",
        "iam:ListMFADevices"
      ],
      "Resource": [
        "arn:aws:iam::*:mfa/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "RestrictToWhitelistedIPs" {
  name        = "RestrictToWhitelistedIPs"
  description = "Only allow to operate from the Whitelisted IPs"
  path        = "/custom/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect" : "Deny",
      "Resource" : [
        "*"
      ],
      "Action" : [
        "*"
      ],
      "Condition" : {
        "NotIpAddress" : {
          "aws:SourceIp" : ${jsonencode(var.allowed_ips)}
        }
      }
    }
  ]
}
EOF
}
