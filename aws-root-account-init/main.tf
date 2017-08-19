resource "aws_iam_account_alias" "root_account_alias" {
  account_alias = "${var.root_account_alias}"
}
