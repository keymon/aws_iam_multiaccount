#!/bin/bash
#
# Add the current IP to the list of whitelisted IPs for a policy
#
set -e -u -o pipefail

ROOT_ACCOUNT_ID="$(pass keytwine/aws/root/account_id)"

ACCOUNT_IDS="
  $(pass keytwine/aws/gfl/account_id)
  $(pass keytwine/aws/root/account_id)
  $(pass keytwine/aws/sandbox/account_id)
"
WHITELIST_IP_POLICY_UPDATE_ROLE=whitelist_ips_updater
WHITELIST_IP_POLICY_NAME=custom/RestrictToWhitelistedIPs

add_ip_to_policy() {
  local ipaddress="$1"
  jq \
    --arg ipaddress "${ipaddress}" \
    '.Statement[0].Condition.NotIpAddress."aws:SourceIp" |= ((.+ [$ipaddress]) | unique)'
}

get_sts_token() {
  local account_id="${1}"
  local role_name="${2}"
  local session_name="${3}"
  local role_arn="arn:aws:iam::${account_id}:role/${role_name}"
  local duration=900

  local caller_arn="$(aws sts get-caller-identity --query Arn --output text)"

  # Ask for MFA if the caller is a user. Skip for assumed roles.
  if echo "${caller_arn}" | grep -qe "arn:aws:iam::[0-9]\+:user/.*"; then
    local token_arn="${caller_arn/:user/:mfa}"
    local user_name="${caller_arn#*/}"
    read -p "MFA Token code for ${caller_arn}: " token
  fi

  aws sts \
    assume-role \
    --role-arn "${role_arn}" \
    --role-session-name "${session_name}" \
    --duration-seconds "${duration}" \
    ${token:+--serial-number "${token_arn}" --token-code "${token}"} \
    --output text \
    --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' \
    | \
      awk '{ print \
        "export AWS_ACCESS_KEY_ID=\"" $1 "\";\n" \
        "export AWS_SECRET_ACCESS_KEY=\"" $2 "\";\n" \
        "export AWS_SESSION_TOKEN=\"" $3 "\";\n" \
        "export -n AWS_SECURITY_TOKEN;\n" \
        "export -n AWS_VAULT;\n" \
      }'
}

get_policy() {
  local account_id="${1}"
  local policy_name="${2}"
  local policy_arn="arn:aws:iam::${account_id}:policy/${policy_name}"
  policy_version=$(
    aws iam get-policy \
      --policy-arn "${policy_arn}" \
      --output text \
      --query 'Policy.DefaultVersionId'
  )
  aws iam get-policy-version \
    --policy-arn "${policy_arn}" \
    --version-id "${policy_version}" \
    --query 'PolicyVersion.Document'
}

delete_oldest_policy_version() {
  local account_id="${1}"
  local policy_name="${2}"
  local policy_arn="arn:aws:iam::${account_id}:policy/${policy_name}"
  oldest_version="$(
    aws iam list-policy-versions \
      --policy-arn "${policy_arn}" |
      jq -r '.Versions | sort_by(.CreateDate) | map(select(.IsDefaultVersion == false)) | .[0].VersionId'
  )"
  if [ ! -z "${oldest_version}" ] && [ "${oldest_version}" != "null" ]; then
    echo "Deleting old version of policy ${policy_arn}:${oldest_version}"
    aws iam delete-policy-version \
      --policy-arn "${policy_arn}" \
      --version-id "${oldest_version}"
  fi
}

update_policy() {
  local account_id="${1}"
  local policy_name="${2}"
  local policy_document="${3}"
  local policy_arn="arn:aws:iam::${account_id}:policy/${policy_name}"
  delete_oldest_policy_version "${account_id}" "${policy_name}"
  aws iam create-policy-version \
    --policy-arn "${policy_arn}" \
    --policy-document "${policy_document}" \
    --set-as-default > /dev/null
}

add_ip_to_policy_in_account() {
  (
    local account_id="${1}"
    local role_name="${2}"
    local policy_name="${3}"
    local current_ip="${4}"

    echo "Adding IP ${current_ip} in policy ${policy_name} for account ${account_id}"

    # Retrieve new tokens for each subaccount
    eval $(get_sts_token "${account_id}" "${role_name}" "whitelist_ips_updater+${current_ip}")

    old_policy_document="$(get_policy "${account_id}" "${policy_name}" | jq -cS .)"
    updated_policy_document="$(echo "${old_policy_document}" | add_ip_to_policy "${current_ip}" | jq -cS .)"

    if [ "${old_policy_document}" != "${updated_policy_document}" ]; then
      update_policy "${account_id}" "${policy_name}" "${updated_policy_document}"
      echo "Policy updated to add IP ${current_ip}."
    else
      echo "Policy is the same. Is IP ${current_ip} already added?. Skipping."
      echo "Curreny policy:"
      echo "${old_policy_document}" | jq .
    fi
  )
}

current_ip="$(curl -qs ifconfig.co)"

# Retrieve first token with MFA auth for the root account
eval "$(get_sts_token "${ROOT_ACCOUNT_ID}" "${WHITELIST_IP_POLICY_UPDATE_ROLE}" "whitelist_ips_updater+${current_ip}")"

for account_id in ${ACCOUNT_IDS}; do
  add_ip_to_policy_in_account "${account_id}" \
    "${WHITELIST_IP_POLICY_UPDATE_ROLE}" \
    "${WHITELIST_IP_POLICY_NAME}" \
    "${current_ip}"
done
