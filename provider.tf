provider "aws" {
  region = "${var.aws_default_region}"
  allowed_account_ids = [
    "${var.root_account_id}",
    "${var.sub_account_id_sandbox}"
  ]
  assume_role {
    role_arn     = "arn:aws:iam::${var.root_account_id}:role/admin"
    session_name = "terraform-aws-iam-user-init"
  }
}
