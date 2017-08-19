#!/bin/bash

. "$(dirname $0)/common.sh"

set -e -u -o pipefail
access_key_id="$(
  run_awscli iam list-access-keys \
    --query AccessKeyMetadata[0].AccessKeyId \
    --output text
)"
run_awscli iam update-access-key \
  --access-key-id "${access_key_id}" \
  --status Inactive
