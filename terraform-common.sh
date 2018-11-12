PROJECT_ROOT=$(git rev-parse --show-toplevel)
PROJECT_NAME="${PROJECT_ROOT##*/}"
TF_BACKEND_CONFIG="${PROJECT_ROOT}/backend_config.tf"

build_docker() {
  [ -z "${_docker_built:-}" ] || return 0
  (
    echo "Building terraform+awscli docker container image..."
    cd "${PROJECT_ROOT}"
    docker build . -q -t terraform_awscli
  ) 1>&2
  _docker_built=1
}

run_terraform() {
  if [ -z "${DISABLE_DOCKER:-}" ]; then
    build_docker
    docker run --rm  \
      -w "${PROJECT_ROOT}" -v "${PROJECT_ROOT}:${PROJECT_ROOT}" \
      -a stdout -a stderr \
      -i $(tty -s && echo -t) \
      -e AWS_ACCESS_KEY_ID \
      -e AWS_SECRET_ACCESS_KEY \
      -e AWS_SESSION_TOKEN \
      -e AWS_SECURITY_TOKEN \
      $(env | grep TF_VAR_ | cut -f 1 -d = | xargs -n 1 -I{} echo "-e {}" | xargs -I{} echo "{}") \
      terraform_awscli \
      terraform "$@"
  else
    terraform "$@"
  fi
}

run_awscli() {
  if [ -z "${DISABLE_DOCKER:-}" ]; then
    build_docker
    docker run --rm  \
      -a stdout -a stderr \
      -i $(tty -s && echo -t) \
      -e AWS_ACCESS_KEY_ID \
      -e AWS_SECRET_ACCESS_KEY \
      -e AWS_SESSION_TOKEN \
      -e AWS_SECURITY_TOKEN \
      terraform_awscli \
      aws "$@"
  else
    aws "$@"
  fi
}

init_terraform_backend() {
  if [ -f "${TF_BACKEND_CONFIG}" ] && [ "${1:-}" != "force" ]; then
    echo "${TF_BACKEND_CONFIG} already exists, not initializing backend"
    return 0
  fi

  ACCOUNT_ID="$(run_awscli sts get-caller-identity --query Account --output text | tr -d '\r')"
  AWS_REGION="eu-west-1"
  BUCKET_NAME="terraform-tfstate-$(echo "${ACCOUNT_ID}" | shasum | cut -f 1 -d " ")"
  DYNAMODB_TABLE="terraform_locks"

  run_awscli s3api head-bucket \
    --region "${AWS_REGION}" \
    --bucket "${BUCKET_NAME}" > /dev/null 2>&1 || \
    run_awscli s3api create-bucket \
      --region "${AWS_REGION}" \
      --bucket "${BUCKET_NAME}"  \
      --create-bucket-configuration LocationConstraint="${AWS_REGION}"

  run_awscli dynamodb describe-table \
    --region "${AWS_REGION}" \
    --table-name terraform_locks > /dev/null 2>&1 ||
    run_awscli dynamodb create-table \
      --region "${AWS_REGION}" \
      --table-name terraform_locks \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

  cat <<EOF > "${TF_BACKEND_CONFIG}"
terraform {
  backend "s3" {
    bucket         = "${BUCKET_NAME}"
    key            = "${PROJECT_NAME}.tfstate"
    region         = "${AWS_REGION}"
    dynamodb_table = "${DYNAMODB_TABLE}"
  }
}
EOF

  echo "Terraform backend resources created and config has been written in ${TF_BACKEND_CONFIG}"
}
