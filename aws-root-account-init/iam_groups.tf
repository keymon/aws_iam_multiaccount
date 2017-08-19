# Group managed by Amazon IAM
resource "aws_iam_group" "billing_users" {
  name = "billing_users"
}

resource "aws_iam_group_membership" "billing_users" {
  name  = "billing_users_group_membership"
  group = "${aws_iam_group.billing_users.name}"
  users = ["${var.billing_users}"]
}

resource "aws_iam_group" "admin_users" {
  name = "admin_users"
}

resource "aws_iam_group_membership" "admin_users" {
  name  = "admin_users_group_membership"
  group = "${aws_iam_group.admin_users.name}"
  users = ["${var.admin_users}"]
}

resource "aws_iam_group" "dev_users" {
  name = "dev_users"
}

resource "aws_iam_group_membership" "dev_users" {
  name  = "dev_users_group_membership"
  group = "${aws_iam_group.dev_users.name}"
  users = ["${var.dev_users}"]
}

resource "aws_iam_group" "interactive_users" {
  name  = "interactive_users"
}

resource "aws_iam_group_membership" "interactive_users" {
  name  = "interactive_users_group_membership"
  group = "${aws_iam_group.interactive_users.name}"
  users = ["${var.interactive_users}"]
}

# Group permissions
resource "aws_iam_group_policy_attachment" "billing_users_AssumeBillingRole" {
  group      = "${aws_iam_group.billing_users.name}"
  policy_arn = "${aws_iam_policy.AssumeBillingRole.arn}"
}

resource "aws_iam_group_policy_attachment" "admin_users_AssumeAdminRole" {
  group      = "${aws_iam_group.admin_users.name}"
  policy_arn = "${aws_iam_policy.AssumeAdminRole.arn}"
}

resource "aws_iam_group_policy_attachment" "dev_users_AssumeSubAccountDevRole" {
  group      = "${aws_iam_group.dev_users.name}"
  policy_arn = "${aws_iam_policy.AssumeSubAccountDevRole.arn}"
}

resource "aws_iam_group_policy_attachment" "interactive_users_SelfManageAccount" {
  group      = "${aws_iam_group.interactive_users.name}"
  policy_arn = "${aws_iam_policy.SelfManageAccount.arn}"
}
