#!/bin/bash
set -e -u -o pipefail

cd "$(dirname "$0")"

. ./terraform-common.sh
[ -f ./terraform-vars.sh ] && . ./terraform-vars.sh

case "${1:-}" in
  init-backend)
    shift
    init_terraform_backend "$@"
    ;;
  *)
    run_terraform "$@"
    ;;
esac
