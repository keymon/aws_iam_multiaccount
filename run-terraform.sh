#!/bin/sh
set -e -u -o pipefail

cd "$(dirname "$0")"

. ./scripts/common.sh

run_terraform "$@"
