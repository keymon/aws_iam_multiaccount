resource "aws_iam_user" "iam_user" {
  name = "${var.name}"
}

resource "aws_iam_user_login_profile" "iam_user" {
  user                    = "${aws_iam_user.iam_user.name}"
  pgp_key                 = "${var.pgp_key}"
  password_reset_required = true
}

resource "aws_iam_access_key" "iam_user" {
  user    = "${aws_iam_user.iam_user.name}"
  pgp_key = "${var.pgp_key}"
}

data "template_file" "credentials_sh" {
  template = <<EOF

# AWS Credentials for the user ${aws_iam_user.iam_user.name}
export AWS_USER_NAME="${aws_iam_user.iam_user.name}";
export AWS_USER_PASSWORD="$(echo "${aws_iam_user_login_profile.iam_user.encrypted_password}" | base64 -D | gpg -d)";
export AWS_ACCESS_KEY_ID="${aws_iam_access_key.iam_user.id}";
export AWS_SECRET_ACCESS_KEY="$(echo "${aws_iam_access_key.iam_user.encrypted_secret}" | base64 -D | gpg -d)";
EOF
}

