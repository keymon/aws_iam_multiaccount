module "aws-root-account-init" {
  source  = "./aws-root-account-init"

  root_account_id = "${var.root_account_id}"
  root_account_alias = "${var.company_name}-root"

  sub_account_ids = [
    "${var.sub_account_id_sandbox}"
  ]

  interactive_users = [
    "${module.hector_rivas_aws_dev_keytwine_com.name}",
    "${module.hector_rivas_aws_admin_keytwine_com.name}",
    "${module.graciafdez_aws_dev_keytwine_com.name}"
  ]
  billing_users = [
    "${module.hector_rivas_aws_dev_keytwine_com.name}",
    "${module.hector_rivas_aws_admin_keytwine_com.name}"
  ]
  admin_users = [
    "${module.hector_rivas_aws_admin_keytwine_com.name}"
  ]
  dev_users = [
    "${module.hector_rivas_aws_dev_keytwine_com.name}"
  ]

  allowed_ips = "${var.allowed_ips}"
}
