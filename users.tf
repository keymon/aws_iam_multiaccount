module "hector_rivas_aws_admin_keytwine_com" {
  source     = "./aws-iam-user-init"
  name       = "hector.rivas+aws.admin@keytwine.com"
  pgp_key    = "${var.hector_pgp_public_key}"
  account_id = "${var.root_account_id}"
}

output "hector_rivas_aws_admin_keytwine_com_credentials_sh" {
  value = "${module.hector_rivas_aws_admin_keytwine_com.credentials_sh}"
}

module "hector_rivas_aws_dev_keytwine_com" {
  source     = "./aws-iam-user-init"
  name       = "hector.rivas+aws.dev@keytwine.com"
  pgp_key    = "${var.hector_pgp_public_key}"
  account_id = "${var.root_account_id}"
}

output "hector_rivas_aws_dev_keytwine_com_credentials_sh" {
  value = "${module.hector_rivas_aws_dev_keytwine_com.credentials_sh}"
}

module "graciafdez_aws_dev_keytwine_com" {
  source     = "./aws-iam-user-init"
  name       = "graciafdez+aws.keytwine@gmail.com"
  pgp_key    = "${var.gfl_pgp_public_key}"
  account_id = "${var.root_account_id}"
}

output "graciafdez_aws_dev_keytwine_com_credentials_sh" {
  value = "${module.graciafdez_aws_dev_keytwine_com.credentials_sh}"
}
