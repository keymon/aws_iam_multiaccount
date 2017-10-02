provider "aws" {
  region = "${var.aws_default_region}"
  allowed_account_ids = [
    "${var.root_account_id}",
    "${var.sub_account_id_sandbox}",
    "${var.sub_account_id_gfl}"
  ]
}
