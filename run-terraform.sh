#!/bin/sh
set -e -u -o pipefail

cd "$(dirname "$0")"

. ./scripts/common.sh

export TF_VAR_root_account_id="$(pass keytwine/aws/root/account_id)"
export TF_VAR_allowed_ips="$(pass keytwine/aws/allowed_ips.json)"
export TF_VAR_sub_account_ids="[
	\"$(pass keytwine/aws/sandbox/account_id)\"
]"

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
