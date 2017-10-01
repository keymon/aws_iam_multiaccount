variable "aws_default_region" {
  default = "eu-west-1"
}

variable "root_account_id" {
  description = "AWS account ID of the root account"
}

variable "sub_account_id" {
  description = "AWS account ID of the sub-account"
}

variable "sub_account_alias" {
  description = "AWS account alias to set for this sub account"
}

variable "terraform_assume_role" {
  description = "Role to assume by terraform. Change it during bootstrap to define an alternate role created manually"
  default = "admin"
}

variable "allowed_ips" {
  description = "List of IPs allowed to operate with these accounts"
  type        = "list"
}
