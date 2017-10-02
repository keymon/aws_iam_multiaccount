module "aws-subaccount-account-init-gfl" {
  source  = "./aws-sub-account-init"

  root_account_id = "${var.root_account_id}"
  sub_account_id = "${var.sub_account_id_gfl}"
  sub_account_alias = "${var.company_name}-gfl"

  allowed_ips = "${var.allowed_ips}"

  # Only used during bootstrap
  # terraform_assume_role = "subaccount-admin"
}

