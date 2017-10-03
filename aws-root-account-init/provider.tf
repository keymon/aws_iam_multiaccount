provider "aws" {
  region = "${var.aws_default_region}"
  allowed_account_ids = ["${var.root_account_id}"]
}
data "aws_caller_identity" "current" {}
