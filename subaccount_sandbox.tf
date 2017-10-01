module "aws-subaccount-account-init-sandbox" {
  source  = "./aws-sub-account-init"

  root_account_id = "${var.root_account_id}"
  sub_account_id = "${var.sub_account_id_sandbox}"
  sub_account_alias = "${var.company_name}-sandbox"

  allowed_ips = "${var.allowed_ips}"

  # Only used during bootstrap
  # terraform_assume_role = "subaccount-admin"
}

