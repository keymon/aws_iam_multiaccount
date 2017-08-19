#!/bin/bash
set -e -u -o pipefail
access_key_id="$(
  aws iam list-access-keys \
    --query AccessKeyMetadata[0].AccessKeyId \
    --output text
)"
aws iam update-access-key \
  --access-key-id "${access_key_id}" \
  --status Inactive
