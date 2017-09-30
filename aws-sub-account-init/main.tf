resource "aws_iam_account_alias" "sub_account_alias" {
  account_alias = "${var.sub_account_alias}"
}
