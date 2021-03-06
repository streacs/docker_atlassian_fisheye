#!/bin/bash

DOCKER_REPOSITORY="streacs"
APPLICATION_NAME="atlassian-fisheye"

APPLICATION_RSS="https://my.atlassian.com/download/feeds/fisheye.rss"

APPLICATION_BRANCH="$(git symbolic-ref --short HEAD)"

function docker_signin {
  docker login -u $bamboo_docker_username -p $bamboo_docker_password
}

function build_container {
  case $APPLICATION_BRANCH in
    master)
      GIT_HASH="$(git rev-parse --short HEAD)"
      APPLICATION_RELEASE="$(wget -qO- ${APPLICATION_RSS} | grep -o -E "(\d{1,2}\.){2,3}\d" | uniq)"
      echo "Building MASTER (${GIT_HASH}) with RELEASE $APPLICATION_RELEASE"
      docker build --no-cache -t ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:master -t ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE} --build-arg APPLICATION_RELEASE=${APPLICATION_RELEASE} .
    ;;
    develop)
      GIT_HASH="$(git rev-parse --short HEAD)"
      APPLICATION_RELEASE="$(wget -qO- ${APPLICATION_RSS} | grep -o -E "(\d{1,2}\.){2,3}\d" | uniq)"
      echo "Building DEVELOP (${GIT_HASH}) with RELEASE $APPLICATION_RELEASE"
      docker build --no-cache -t ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:develop --build-arg APPLICATION_RELEASE=${APPLICATION_RELEASE} .
    ;;
    release*)
      GIT_HASH="$(git rev-parse --short HEAD)"
      APPLICATION_RELEASE="$(git symbolic-ref --short HEAD | grep -o -E "(\d{1,2}\.){2,3}\d")"
      echo "Building RELEASE (${GIT_HASH}) with RELEASE $APPLICATION_RELEASE"
      docker build --no-cache -t ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE} --build-arg APPLICATION_RELEASE=${APPLICATION_RELEASE} .
    ;;
    feature*)
      GIT_HASH="$(git rev-parse --short HEAD)"
      APPLICATION_RELEASE="$(wget -qO- ${APPLICATION_RSS} | grep -o -E "(\d{1,2}\.){2,3}\d" | uniq)"
      echo "Building FEATURE (${GIT_HASH}) with BRANCH $APPLICATION_BRANCH and RELEASE $APPLICATION_RELEASE"
      docker build --no-cache -t ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:feature-${GIT_HASH} --build-arg APPLICATION_RELEASE=${APPLICATION_RELEASE} .
    ;;
    *)
      echo "No match found"
    ;;
  esac
}

function test_container {
  case $APPLICATION_BRANCH in
    master)
      docker run -t --rm --env-file files/environment.list ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:master rake spec /home/fisheye/spec
    ;;
    develop)
      docker run -t --rm --env-file files/environment.list ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:develop rake spec /home/fisheye/spec
    ;;
    release*)
      APPLICATION_RELEASE="$(git symbolic-ref --short HEAD | grep -o -E "(\d{1,2}\.){2,3}\d")"
      docker run -t --rm --env-file files/environment.list ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE} rake spec /home/fisheye/spec
    ;;
    feature*)
      GIT_HASH="$(git rev-parse --short HEAD)"
      docker run -t --rm --env-file files/environment.list ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:feature-${GIT_HASH} rake spec /home/fisheye/spec
    ;;
    *)
      echo "No match found"
    ;;
  esac
}

function remove_container {
  case $APPLICATION_BRANCH in
    master)
      APPLICATION_RELEASE="$(wget -qO- ${APPLICATION_RSS} | grep -o -E "(\d{1,2}\.){2,3}\d" | uniq)"
      docker rmi ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:master
      docker rmi ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE}
    ;;
    develop)
      docker rmi ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:develop
    ;;
    release*)
      APPLICATION_RELEASE="$(git symbolic-ref --short HEAD | grep -o -E "(\d{1,2}\.){2,3}\d")"
      docker rmi ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE}
    ;;
    feature*)
      GIT_HASH="$(git rev-parse --short HEAD)"
      docker rmi ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:feature-${GIT_HASH}
    ;;
    *)
      echo "No match found"
    ;;
  esac
}

function deploy_container {
  case $APPLICATION_BRANCH in
    master)
      APPLICATION_RELEASE="$(wget -qO- ${APPLICATION_RSS} | grep -o -E "(\d{1,2}\.){2,3}\d" | uniq)"
      docker push ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:master
      docker push ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE}
    ;;
    develop)
      docker push ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:develop
    ;;
    release*)
      APPLICATION_RELEASE="$(git symbolic-ref --short HEAD | grep -o -E "(\d{1,2}\.){2,3}\d")"
      docker push ${DOCKER_REPOSITORY}/${APPLICATION_NAME}:${APPLICATION_RELEASE}
    ;;
    feature*)
      echo "Nothing to do"
    ;;
    *)
      echo "No match found"
    ;;
  esac
}

case $1 in
  package)
    build_container
    test_container
    docker_signin
    deploy_container
    remove_container
  ;;
  build)
    build_container
  ;;
  test)
    test_container
  ;;
  deploy)
    docker_signin
    deploy_container
  ;;
  remove)
    remove_container
  ;;
  *)
    echo "No valid arguments provided (package)"
    exit 1
esac