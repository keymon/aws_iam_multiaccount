resource "aws_iam_role" "admin" {
  name               = "admin"
  description        = "Administrator: access to all resources and APIs. Occasional use."
  assume_role_policy = "${data.template_file.AssumeRoleTrustPolicySubAccountWithMFA.rendered}"
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
  description        = "Normal Developer: operate the account."
  assume_role_policy = "${data.template_file.AssumeRoleTrustPolicySubAccountWithMFA.rendered}"
}

resource "aws_iam_role_policy_attachment" "dev_PowerUserAccess" {
  role       = "${aws_iam_role.dev.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "dev_RestrictToWhitelistedIPs" {
  role       = "${aws_iam_role.dev.name}"
  policy_arn = "${module.aws-ip-restriction.RestrictToWhitelistedIPs_arn}"
}
