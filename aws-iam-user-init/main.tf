variable "name" {
  description = "Name of the user to create. Can be email"
}

variable "pgp_key" {
  description = "GPG Public key in base64: gpg --export 12345678 | base64"
}

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

output "credentials_sh" {
  value = "${data.template_file.credentials_sh.rendered}"
}

output "name" {
  value = "${aws_iam_user.iam_user.name}"
}

output "arn" {
  value = "${aws_iam_user.iam_user.arn}"
}
