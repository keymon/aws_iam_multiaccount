provider "aws" {
  region = "${var.aws_default_region}"
  allowed_account_ids = ["${var.account_id}"]
}
