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
      "NotResource" : [
        "${aws_iam_role.whitelist_ips_updater.arn}"
      ],
      "NotAction" : [
        "sts:AssumeRole"
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

resource "aws_iam_policy" "AllowUpdateRestrictToWhitelistedIPs" {
  name        = "AllowUpdateRestrictToWhitelistedIPs"
  description = "Allow to update the RestrictToWhitelistedIPs policy"
  path        = "/custom/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect" : "Allow",
      "Resource" : [
        "${aws_iam_policy.RestrictToWhitelistedIPs.arn}"
      ],
      "Action" : [
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:ListPolicyVersions",
        "iam:DeletePolicyVersion",
        "iam:CreatePolicyVersion"
      ],
      "Condition": {
        "StringLike": {
          "aws:userid": [
            "*:whitelist_ips_updater+$${aws:SourceIp}"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": [
        "arn:aws:iam::*:role/whitelist_ips_updater"
      ]
    }
  ]
}
EOF
}
