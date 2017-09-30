# aws_base_iam_multiaccount

Configure base AWS account IAM policies automatically using terraform.

## Bootstrap: first manual configuration

Follow the instructions in [`BOOTSTRAP.md`](./BOOTSTRAP.md) to
initalise your account or add new subaccounts.

## Allow usage only from whitelisted IPs

This repository adds a policy to only allow access from a list whitelisted IPs.

These IPs are configured in `pass keytwine/aws/allowed_ips.json` and it
will also pick the current IP when running terraform apply.

But if the IP is not added, currently the only way is login with the root account
and edit the policy automatically.

# Credits

Based on: https://medium.com/@PatrikKarisch/automated-aws-account-initialization-with-terraform-and-onelogin-saml-sso-1301ff4851ab
