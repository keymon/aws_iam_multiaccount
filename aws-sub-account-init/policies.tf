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
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.root_account_id}:role/admin"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  vars {
    root_account_id = "${var.root_account_id}"
  }
}
