#!/bin/bash
set -e -u -o pipefail

cd "$(dirname "$0")"

. ./scripts/common.sh

current_ip="$(curl -qs ifconfig.co)"

export TF_VAR_root_account_id="$(pass keytwine/aws/root/account_id)"
export TF_VAR_sub_account_id_sandbox="$(pass keytwine/aws/sandbox/account_id)"
export TF_VAR_sub_account_id_gfl="$(pass keytwine/aws/gfl/account_id)"
export TF_VAR_allowed_ips="$(
	pass keytwine/aws/allowed_ips.json |
		jq -r --arg current_ip "$current_ip" ' . += [$current_ip] | unique'
)"

case "${1:-}" in
  init-backend)
    init_terraform_backend
    ;;
  init)
    run_terraform init
    run_terraform get
    ;;
  *)
    run_terraform "$@"
    ;;
esac
