#!/usr/bin/env bash

# Prerequisite
# Make sure you set secret enviroment variables in CI
# DOCKER_USERNAME
# DOCKER_PASSWORD

set -e

# usage
Usage() {
  echo "$0 <image_name>"
}

if [ $# -eq 0 ]; then
  Usage
  exit 1
fi

image="alpine/$1"
platform="${2:-linux/arm64,linux/amd64}"

curl -H "Cache-Control: no-cache" -sL "https://raw.githubusercontent.com/alpine-docker/multi-arch-docker-images/stable/functions.sh" -o functions.sh
source functions.sh

tag=$(get_latest_release curl/curl |sed 's/curl-//')
curl_tag=$(get_latest_release curl/curl)
quiche_tag=$(get_latest_release cloudflare/quiche)
#build_arg="CURL_VERSION=${curl_tag} QUICHE_VERSION=${quiche_tag}"

echo "Building image for tag: ${tag}"
export CURL_VERSION=${curl_tag}
export QUICHE_VERSION=${quiche_tag}

ARGS=(
  --build-arg CURL_VERSION=$CURL_VERSION
  --build-arg QUICHE_VERSION=$QUICHE_VERSION
)

# build_docker_image "${tag}" "${image}" "${platform}" "${build_arg}"

# Create a new buildx builder instance
builder_name=$(uuidgen)
docker buildx create --use --name "mybuilder-${builder_name}"

if [[ "$CIRCLE_BRANCH" == "master" || "$CIRCLE_BRANCH" == "main" ]]; then
  docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
  docker buildx build --progress=plain --push \
   --platform "${platform}" \
   "${ARGS[@]}" \
   --no-cache \
   --attest type=provenance,mode=max \
   --tag "${image}:${tag}" \
   --tag "${image}:latest" \
   .
fi

# Clean up the builder instance
docker buildx rm "mybuilder-${builder_name}"

