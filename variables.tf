variable "company_name" {
  default = "keytwine"
}

variable "aws_default_region" {
    default = "eu-west-1"
}

variable "root_account_id" {
    description = "Root account id"
}

variable "sub_account_ids" {
    description = "AWS Sub account ids"
    type        = "list"
}

# gpg --export -a 2EA619ED
variable "hector_pgp_public_key" {
    default = "mQENBFNZGecBCACZ6PGFrJoHUiJtRL8GGNu5AYLzNVqwGFRlFx+hc/Yx+o2feWhdT3rVfkluTepsXEcy6lWGoip8LkTaWZro0TFvoPrjIWoSKy8BwUb9Lj19vg71nZYE6vKtJrOzdcuux2LJDa857KscN7oIDUycHi6Ec9ezzAbJ/ZS4xqpRqL1uiNF70c9x5GA2ZXmslq3ZtnL2IVf46CfcbzQuiexYgQbGGMhqxYfmmd0AqldKmu4WaiQMCpbHUhZdirzQdNb03+OPu3UM2aunGj+ukF+2E+YEFNDTbDLdb4cyty0n1XCN3N9lfe0Ma06pWDCEqP8J7615lzO7wK6AAghA7CvvD3/XABEBAAG0OkhlY3RvciBSaXZhcyBHYW5kYXJhIChwYXNzd29yZC1zdG9yYWdlKSA8a2V5bW9uQGdtYWlsLmNvbT6JATgEEwECACIFAlNZGecCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJELWTF3cuphnt9igH/2zKebb2m4OS9k8KzAOE3xd77ZMs5W3JNh9mvHBzSEzyqoF356qP9bg2Q1R9jl4JnREdir9MdVC55jSHN04pvfQUcMXx7nnCvPhIY8E2Hp7YUbGJ+zDRh2SPb+LWrXL2Fg9kJwSPdOAV67aw369Mr/2lI70822ioY1jWx08sdUSLgVirfptplmloYi5y0/b+VCzM01ATsn+ORgbVEI2ClSNp5LT0oXm4BQwrtq+ebxqeBmm9Ujj835mlEsMSTyIE+r4PSD9a6vz03RdavILW+01QV1H4o8W2F2k+BCt/KCbeF/oZcNe9Jnqey5GCukXoeKvUk1JhgVBxfFN45KIrP1i5AQ0EU1kZ5wEIAK2m5B7bIcxg4u8FIeCwaVeXpW8z4KxM9YAFuSxEMHPeWvzJolOv9j+McIlbDNKSaWKMYyUwMhwzcInhTVqoEW5hU3FxF7mUrSqNqW6IUo86BSscsbwciDv8hgInWeZVvbFh/+J77tg09Y/UxmRs0dnh7Xoyq1NYZtiD3uKddULeI3rmvFs/QiKh0Du9q73+kvZi+Ph/KLNoZXRlUi+In4+7u3hOEcgryLvqIb8BT/ARic3jf+Hqhf/X0A7ji1TEy6PdYOXqzuh7qSqb3lScKzjH3Otda4q/BpPye7xS1uLxXgIhtMjqS1BrgVPXdMVnveZ7EhCgGeT+pdY25RGTmHsAEQEAAYkBHwQYAQIACQUCU1kZ5wIbDAAKCRC1kxd3LqYZ7aelB/9xFFIhYE5s0Q8mtUL0yfgF2XvW2kDdqnLbKX7d1xjElV31J39RMMYRTZlEhgvjoRhFgmOQagcBYUpdkxc8Q3hqJQOYDw4x9J/aLBug5ynEPSehScuDp9L5Vkt8kcedF25Yhs0UVuPNKyzNCKo/hoj+kCFNcidajhL1LQXZrPtXJVEQMyRVrCijapvbYcbU2guuh4smiJOpqGEQjEkwQfORZtQRy7iylQYAJEEmp6sUxMraKtk31o/Uu13GgvmvOy5MowMBLZJDyf624DPtYDVbidOrNC4Z2LaUOLMqG+DUSRxzY5yuxSFuvlu9xSzvDU1umQkv+gUfW/u0TVdZSIq1"
}

variable "allowed_ips" {
  description = "List of IPs allowed to operate with these accounts"
  type        = "list"
}
