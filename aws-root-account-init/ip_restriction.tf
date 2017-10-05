module "aws-ip-restriction" {
  source          = "../aws-ip-restriction"
  allowed_ips     = "${var.allowed_ips}"
  root_account_id = "${var.root_account_id}"
}
