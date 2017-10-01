provider "aws" {
  region = "${var.aws_default_region}"
  allowed_account_ids = ["${var.account_id}"]
  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/admin"
    session_name = "terraform-aws-iam-user-init"
  }
}
