provider "aws" {
  region = "${var.aws_default_region}"
  allowed_account_ids = ["${var.root_account_id}"]
  assume_role {
    role_arn     = "arn:aws:iam::${var.root_account_id}:role/${var.terraform_assume_role}"
    session_name = "terraform-aws-subaccount-init"
  }
}
