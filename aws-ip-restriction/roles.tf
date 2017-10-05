resource "aws_iam_role" "whitelist_ips_updater" {
  name               = "whitelist_ips_updater"
  description        = "Role allowed to update the Policy with whitelisted IPs"
  assume_role_policy = <<EOF
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
        "AWS": "arn:aws:iam::${var.root_account_id}:role/whitelist_ips_updater"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "whitelist_ips_updater_AllowUpdateRestrictToWhitelistedIPs" {
  role       = "${aws_iam_role.whitelist_ips_updater.name}"
  policy_arn = "${aws_iam_policy.AllowUpdateRestrictToWhitelistedIPs.arn}"
}


