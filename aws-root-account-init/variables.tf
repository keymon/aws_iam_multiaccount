variable "aws_default_region" {
  default = "eu-west-1"
}

variable "root_account_id" {
  description = "AWS account ID of the root account"
}

variable "root_account_alias" {
  description = "AWS account alias to set in the root account"
}

variable "sub_account_ids" {
  description = "List of AWS account ID associated to this account"
  type        = "list"
}

variable "interactive_users" {
  description = "List of native users that would be use interactivelly"
  type        = "list"
}

variable "billing_users" {
  description = "List of native users to add to billing-users group, allowed to assume role billing"
  type        = "list"
}

variable "admin_users" {
  description = "List of native users to add to admin-users group, allowed to assume role admin"
  type        = "list"
}

variable "dev_users" {
  description = "List of native users to add to dev-users group, allowed to assume role dev"
  type        = "list"
}
