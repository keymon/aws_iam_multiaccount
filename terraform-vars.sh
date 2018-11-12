current_ip="$(curl -qs ifconfig.co)"

export TF_VAR_root_account_id="$(pass keytwine/aws/root/account_id)"
export TF_VAR_sub_account_id_sandbox="$(pass keytwine/aws/sandbox/account_id)"
export TF_VAR_sub_account_id_gfl="$(pass keytwine/aws/gfl/account_id)"
export TF_VAR_allowed_ips="$(
	pass keytwine/aws/allowed_ips.json |
		jq -r --arg current_ip "$current_ip" ' . += [$current_ip] | unique'
)"
