#!/bin/bash

PATH_TO_BUILD_CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PATH_TO_BAO_ROOT_DIR="$(echo ${PATH_TO_BUILD_CONTEXT} | awk 'BEGIN{FS=OFS="/"}{NF--;printf $0}')"

CONTAINER_TAG="fenxi:local-ci"

touch "${PATH_IID_FILE}"

sudo docker build \
         -t "${CONTAINER_TAG}" \
         --file="${PATH_TO_BUILD_CONTEXT}/Dockerfile" \
         "${PATH_TO_BUILD_CONTEXT}"

echo "Starting Fenxi in docker container"

sudo docker run \
	-v "${PATH_TO_BAO_ROOT_DIR}:${PATH_TO_BAO_ROOT_DIR}" \
    -w "${PATH_TO_BAO_ROOT_DIR}" \
    -it "${CONTAINER_TAG}" \
    /bin/bash -c "$*"