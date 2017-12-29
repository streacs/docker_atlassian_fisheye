#!/bin/bash

DOCKER_REPOSITORY="streacs"
APPLICATION_NAME="atlassian-fisheye"

APPLICATION_RSS="https://my.atlassian.com/download/feeds/fisheye.rss"

APPLICATION_BRANCH="$(git symbolic-ref --short HEAD)"

function build_container {
      APPLICATION_RELEASE="$(wget -qO- ${APPLICATION_RSS} | grep -o -E "(\d{1,2}\.){2,3}\d" | uniq)"
      docker build --no-cache --build-arg APPLICATION_RELEASE=${APPLICATION_RELEASE} -t ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:latest .
}

function remove_container {
      docker rmi ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:latest
}

case $1 in
  package)
    build_container
  ;;
  test)
    build_container
    remove_container
  ;;
  *)
    echo "No valid arguments provided (package)"
    exit 1
esac