#!/bin/bash
###
# title             : NWI Ubuntu Docker EE install script
# file              : shell script
# www-site          : http://www.nebulaworks.com
# description       : Nebulaworks Docker Enterprise edition install script
# executor-version  : bash
###

## Use as ./dockerinstallscript.sh --version 17.06.2~ee~6-0~ubuntu --url https://storebits.docker.com/ee/m/sub-4409739d-251b-4cc5-9efb-567c8e84c023

set -e

readonly SCRIPT_NAME="$(basename "$0")"

function print_usage {
  echo
  echo "Usage: install-docker [OPTIONS]"
  echo
  echo "This script can be used to install Docker EE. It has been tested with"
  echo "Ubuntu 16.04"
  echo
  echo "Options:"
  echo
  echo -e "  --version\t\tThe version of Docker to install. Required."
  echo -e "  --url\t\tThe Docker EE URL. Required."
  echo
  echo "Example:"
  echo
  echo "  install-docker --version 17.06.2~ee~6-0~ubuntu --url https://storebits                                                                                        .docker.com/ee/ubuntu/sub-1234"
}

function log {
  local level="$1"
  local message="$2"
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local message="$1"
  log "INFO" "$message"
}

function log_error {
  local message="$1"
  log "ERROR" "$message"
}

function assert_not_empty {
  local arg_name="$1"
  local arg_value="$2"

  if [[ -z "$arg_value" ]]; then
    log_error "The value for '$arg_name' cannot be empty"
    print_usage
    exit 1
  fi
}


function install_docker {
  local version="$1"
  local url="$2"


  log_info "Uninstalling old versions"
  sudo apt-get remove docker docker-engine docker-ce docker.io

  log_info "Updating the apt package index"
  sudo apt-get update

  log_info "Installing packages to allow apt to use a repository over HTTPS"
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

  log_info "Adding Dockers' official GPG key using your customer Docker EE"
  curl -fsSL "$url/ubuntu/gpg" | sudo apt-key add -

  log_info "Setting up the stable repository"
  sudo add-apt-repository \
    "deb [arch=amd64] $url/ubuntu \
    $(lsb_release -cs) \
    stable-17.06"

  log_info "Updating the apt package index"
  sudo apt-get update

  log_info "Installing Docker EE"
  sudo apt-get install -y "docker-ee=$version"
}


function docker_configuration {

  log_info "Configuring docker to start on boot"
  sudo systemctl enable docker

  log_info "Configuring storage driver"
  sudo mkdir -p /etc/docker
  sudo bash -c 'cat << _EOF_ > /etc/docker/daemon.json
{
  "data-root": "/data01",
  "storage-driver": "overlay2"
}
_EOF_'

  log_info "Restarting docker engine"
  sudo systemctl restart docker

}

function main {
  local version=""
  local url=""

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case "$key" in
      --version)
        version="$2"
        shift
        ;;
      --url)
        url="$2"
        shift
        ;;
      *)
        log_error "Unrecognized argument: $key"
        print_usage
        exit 1
        ;;
    esac

    shift
  done

  assert_not_empty "--version" "$version"
  assert_not_empty "--url" "$url"

  log_info "Starting Docker install"

  install_docker "$version" "$url"
  docker_configuration

  log_info "Docker EE install complete!"
}

main "$@"
