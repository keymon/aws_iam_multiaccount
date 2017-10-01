#!/bin/bash

set -e -u -o pipefail

TTL=3600 # Lasts only 1h
case "$(uname -s)" in
  Darwin)
    EXPIRE_DATE="$(date -r $(($(date +%s)+$TTL)) +%Y-%m-%dT%H:%M:%SZ)"
    ;;
  Linux)
    EXPIRE_DATE="$(date -d @$(($(date +%s)+$TTL)) +%Y-%m-%dT%H:%M:%SZ)"
    ;;
  *)
    echo "Unknown platform"
    exit 1
    ;;
esac
MY_IP="$(curl -qs ifconfig.co)"

ACCOUNT_ID="${ACCOUNT_ID:-${1:-}}"
if [ -z "${ACCOUNT_ID}" ]; then
  cat <<EOF
Pass the root AWS account id as argument. You can get it in the console or running:
  aws sts get-caller-identity --query Account --output text | tr -d '\r'
EOF
  exit 1
fi

cat <<EOF
#
# TerraformInitRestricted: IAM policy with least privileged access which you use to initialise your root account. Delete after usage.
#
{
   "Version" : "2012-10-17",
   "Statement" : [
      {
         "Effect" : "Deny",
         "Resource" : [
            "*"
         ],
         "Action" : [
            "*"
         ],
         "Condition" : {
            "NotIpAddress" : {
               "aws:SourceIp" : [
                  "${MY_IP}"
               ]
            }
         }
      },
      {
         "Effect" : "Deny",
         "Resource" : [
            "*"
         ],
         "Action" : [
            "*"
         ],
         "Condition" : {
            "DateGreaterThan" : {
               "aws:CurrentTime" : "${EXPIRE_DATE}"
            }
         }
      },
      {
         "Effect" : "Allow",
         "Resource" : [
            "*"
         ],
         "Action" : [
            "iam:*"
         ]
      },
      {
         "Effect" : "Allow",
         "Action" : [
            "s3:GetObject",
            "s3:PutObject",
            "s3:CreateBucket",
            "s3:ListBucket"
         ],
         "Resource" : [
            "arn:aws:s3:::terraform-tfstate-*",
            "arn:aws:s3:::terraform-tfstate-*/*"
         ]
      },
      {
         "Effect" : "Allow",
         "Resource" : [
            "arn:aws:dynamodb:*:${ACCOUNT_ID}:table/terraform_locks"
         ],
         "Action" : [
            "dynamodb:CreateTable",
            "dynamodb:DescribeTable",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:BatchGetItem"
         ]
      }
   ]
}
EOF
