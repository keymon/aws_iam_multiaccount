data "template_file" "AssumeRoleTrustPolicySubAccountWithMFA" {
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
