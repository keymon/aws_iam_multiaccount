variable "allowed_ips" {
  description = "List of IPs allowed to operate with these accounts"
  type        = "list"
}

variable "root_account_id" {
  description = "AWS account ID of the root account where the users are defined"
}
