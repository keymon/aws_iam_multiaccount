variable "aws_default_region" {
  default = "eu-west-1"
}

variable "name" {
  description = "Name of the user to create. Can be email"
}

variable "pgp_key" {
  description = "GPG Public key in base64: gpg --export 12345678 | base64"
}

variable "account_id" {
  description = "AWS account ID where create the user"
}
