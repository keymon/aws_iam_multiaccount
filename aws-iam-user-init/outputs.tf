output "credentials_sh" {
  value = "${data.template_file.credentials_sh.rendered}"
}

output "name" {
  value = "${aws_iam_user.iam_user.name}"
}

output "arn" {
  value = "${aws_iam_user.iam_user.arn}"
}
