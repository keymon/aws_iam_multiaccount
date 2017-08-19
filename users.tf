module "hector_rivas_aws_admin_keytwine_com" {
  source  = "./aws-iam-user-init"
  name    = "hector.rivas+aws.admin@keytwine.com"
  pgp_key = "${var.hector_pgp_public_key}"
}

output "hector_rivas_aws_admin_keytwine_com_credentials_sh" {
  value = "${module.hector_rivas_aws_admin_keytwine_com.credentials_sh}"
}

module "hector_rivas_aws_dev_keytwine_com" {
  source  = "./aws-iam-user-init"
  name    = "hector.rivas+aws.dev@keytwine.com"
  pgp_key = "${var.hector_pgp_public_key}"
}

output "hector_rivas_aws_dev_keytwine_com_credentials_sh" {
  value = "${module.hector_rivas_aws_dev_keytwine_com.credentials_sh}"
}
