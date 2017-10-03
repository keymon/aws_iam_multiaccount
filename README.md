# aws_base_iam_multiaccount

Configure base AWS account IAM policies automatically using terraform.

## Bootstrap: first manual configuration

Follow the instructions in [`BOOTSTRAP.md`](./BOOTSTRAP.md) to
initalise your account or add new subaccounts.

## Allow usage only from whitelisted IPs

This repository adds a policy to only allow access from a list whitelisted IPs.

These IPs are configured in `pass keytwine/aws/allowed_ips.json` and it
will also pick the current IP when running terraform apply.

If the IP is not alllowed, you can load the user AWS admi ncredentials
and run `./scripts/whitelist_current_ip.sh`.  For example, using the
[`awssts`](https://github.com/keymon/aws_key_management/blob/master/awssts.sh)
tool:

    awssts user:hector.rivas+admin@keytwine \
          ./scripts/whitelist_current_ip.sh

# Credits

Based on: https://medium.com/@PatrikKarisch/automated-aws-account-initialization-with-terraform-and-onelogin-saml-sso-1301ff4851ab
