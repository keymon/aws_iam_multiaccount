# Bootstrap the accounts

The first time you create your account, you need to create some initial steps:

 1. Create a root account
    1. With a long long generated password
    2. Put password policy
    3. Add MFA to user
    4. Deactivate all regions in Account Settings
    5. Store the account id from https://console.aws.amazon.com/billing/home?#/account `pass insert -m keytwine/aws/root/account_id`
    6. Enable [IAM User and Role Access to Billing Information](https://console.aws.amazon.com/billing/home#/account)

 2. Run the script `./scripts/generate_TerraformInitRestricted_policy.sh $(pass keytwine/aws/root/account_id)` and
    manually create the policy `TerraformInitRestricted` with the output.
    It allows  API usage and restricts by IP and time for 1h: `TerraformInitRestricted`.
    Maybe a little bit paranoid, but it is free to have :).

 4. Create `terraform-init` user:
    1. Programatic access only
    2. Attach the policy `TerraformInitRestricted`
    3. Store the credentials:

```
cat <<EOF | pass insert -m -f keytwine/aws/root/terraform-init.credentials.sh
export AWS_ACCOUNT_NAME=terraform-init@keytwine.root
export AWS_ACCESS_KEY_ID=FOFOFOFOFOFOOOOFOFO
export AWS_SECRET_ACCESS_KEY=BARBARBARBARBARBAR
EOF
```

 5. Run terraform. The output will print the new credentials for your users.

```
eval $(keytwine/aws/root/terraform-init.credentials.sh)
./run_terraform.sh apply
```

 6. Now you can disable this account:
    1. Disable the terraform-init AWS keys by running: `./scripts/self_lock_aws_access_key.sh`
    2. Optionally delete the user and policy in the console.

 7. Configure the new users:
    1. Login into the console with each user: https://keytwine-root.signin.aws.amazon.com/console
    2. Change the password
    3. Add a MFA device in IAM > Users > username > MFA

