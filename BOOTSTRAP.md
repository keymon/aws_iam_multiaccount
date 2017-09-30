# Bootstrap the accounts

## Bootstrapping the root account

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
./run_terraform.sh init-backend
./run_terraform.sh init
./run_terraform.sh apply
```

	You will get an output with the credentials of each user.

 6. Now you can disable this bootstrap init user account:
    1. Disable the terraform-init AWS keys by running: `./scripts/self_lock_aws_access_key.sh`
    2. Optionally delete the user and policy using the console.

 7. Finally: Configure the new users:
    1. Send the output of the terraform to each user.
    2. Each user can now login in the console: https://keytwine-root.signin.aws.amazon.com/console and:
		1. Change the password
		2. Add a MFA device in IAM > Users > username > MFA

## Bootstrapping a sub-account

In order to add a new subaccount:

 1. In the consolidated login, create a new subaccount: https://console.aws.amazon.com/organizations/home?#/accounts
	* Set the "IAM role name" to something like `subaccount-admin`
 2. In the code: add a new variable with the subaccount ID: variables.tf,  run-terraform.sh, provider.tf...
 3. Add the call to the subaccount module in `subaccount_<name>.tf`
	* Include the parameters `terraform_assume_role = "subaccount-admin"` for the first run, as the role `admin` does not exist.
 4. Run `./run-terraform.sh apply`

Once the account is setup, you can:

 1. Remove the `terraform_assume_role = "subaccount-admin"` so it would start using the role `admin`
 2. Remove the role `subaccount-admin` form the subaccount, for instance:
    ```
awssts admin@keytwine-sandbox
aws iam delete-role-policy \
	--role-name subaccount-admin \
	--policy-name AdministratorAccess
aws iam delete-role \
	--role-name subaccount-admin
```
