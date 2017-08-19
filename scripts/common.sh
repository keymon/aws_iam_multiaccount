PROJECT_ROOT=$(git rev-parse --show-toplevel)
PROJECT_NAME="${PROJECT_ROOT##*/}"

build_docker() {
  [ -z "${_docker_built:-}" ] || return
  echo "Building terraform+awscli docker container image..."
  (
    cd "${PROJECT_ROOT}"
    docker build . -q -t terraform_awscli
  )
  _docker_built=1
}

run_terraform() {
  if [ -z "${DISABLE_DOCKER:-}" ]; then
    build_docker
    docker run --rm  \
      -w "${PROJECT_ROOT}" -v "${PROJECT_ROOT}:${PROJECT_ROOT}" \
      -i $(tty -s && echo -t) \
      -e AWS_ACCESS_KEY_ID \
      -e AWS_SECRET_ACCESS_KEY \
      -e AWS_SESSION_TOKEN \
      $(env | grep TF_VAR_ | cut -f 1 -d = | xargs -I{} echo "-e {}" | xargs) \
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
      -i $(tty -s && echo -t) \
      -e AWS_ACCESS_KEY_ID \
      -e AWS_SECRET_ACCESS_KEY \
      -e AWS_SESSION_TOKEN \
      terraform_awscli \
      aws "$@"
  else
    aws "$@"
  fi
}
