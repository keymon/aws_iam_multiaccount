module "aws-subaccount-account-init-gfl" {
  source  = "./aws-sub-account-init"

  root_account_id = "${var.root_account_id}"
  sub_account_id = "${var.sub_account_id_gfl}"
  sub_account_alias = "${var.company_name}-gfl"

  allowed_ips = "${var.allowed_ips}"

  # Only used during bootstrap
  # terraform_assume_role = "subaccount-admin"
}

resource "aws_iam_policy" "AssumeAdminRoleGflSubAccount" {
  name        = "AssumeAdminRoleGflSubAccount"
  description = "Allow to assume any role in the gfl subaccounts"
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
          "arn:aws:iam::%s:role/*",
          list(var.sub_account_id_gfl)
        )
      )
    }
  }
}
EOF
}

resource "aws_iam_group" "gfl_admin_users" {
  name  = "gfl_admin_users"
}

resource "aws_iam_group_membership" "gfl_admin_users" {
  name  = "gfl_admin_users_group_membership"
  group = "${aws_iam_group.gfl_admin_users.name}"
  users = [
    "${module.graciafdez_aws_dev_keytwine_com.name}",
    "${module.hector_rivas_aws_admin_keytwine_com.name}",
  ]
}

resource "aws_iam_group_policy_attachment" "gfl_admin_users_AssumeAdminRoleGflSubAccount" {
  group      = "${aws_iam_group.gfl_admin_users.name}"
  policy_arn = "${aws_iam_policy.AssumeAdminRoleGflSubAccount.arn}"
}
