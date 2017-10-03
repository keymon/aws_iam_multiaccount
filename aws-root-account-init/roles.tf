resource "aws_iam_role" "billing" {
  name               = "billing"
  description        = "Billing: To access billing from the console."
  assume_role_policy = "${data.template_file.AssumeRoleTrustPolicyRootAccountWithMFA.rendered}"
}

resource "aws_iam_role_policy_attachment" "billing_AssumeBillingRole" {
  role = "${aws_iam_role.billing.name}"
  policy_arn = "${aws_iam_policy.AssumeBillingRole.arn}"
}

resource "aws_iam_role_policy_attachment" "billing_RestrictToWhitelistedIPs" {
  role       = "${aws_iam_role.billing.name}"
  policy_arn = "${module.aws-ip-restriction.RestrictToWhitelistedIPs_arn}"
}

resource "aws_iam_role_policy_attachment" "billing_BillingAccess" {
  role       = "${aws_iam_role.billing.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_role" "admin" {
  name               = "admin"
  description        = "Administrator: access to all resources and APIs. Occasional use."
  assume_role_policy = "${data.template_file.AssumeRoleTrustPolicyRootAccountWithMFA.rendered}"
}

resource "aws_iam_role_policy_attachment" "admin_AssumeAdminRole" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "${module.aws-ip-restriction.RestrictToWhitelistedIPs_arn}"
}

resource "aws_iam_role_policy_attachment" "admin_AdministratorAccess" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin_RestrictToWhitelistedIPs" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "${module.aws-ip-restriction.RestrictToWhitelistedIPs_arn}"
}

resource "aws_iam_role" "dev" {
  name               = "dev"
  description        = "Normal Developer: access to assume roles in SubAccounts."
  assume_role_policy = "${data.template_file.AssumeRoleTrustPolicyRootAccountWithMFA.rendered}"
}

resource "aws_iam_role_policy_attachment" "dev_AssumeSubAccountDevRole" {
  role       = "${aws_iam_role.dev.name}"
  policy_arn = "${aws_iam_policy.AssumeSubAccountDevRole.arn}"
}

resource "aws_iam_role_policy_attachment" "dev_RestrictToWhitelistedIPs" {
  role       = "${aws_iam_role.dev.name}"
  policy_arn = "${module.aws-ip-restriction.RestrictToWhitelistedIPs_arn}"
}
