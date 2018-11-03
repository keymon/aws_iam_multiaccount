provider "aws" {
  region = "${var.aws_default_region}"
  assume_role {
    role_arn     = "arn:aws:iam::${var.sub_account_id}:role/${var.terraform_assume_role}"
    session_name = "terraform-aws-subaccount-init"
  }
}
