#!/bin/sh

DOCKER_IMAGE=theroozbeh/tj3:latest

docker run \
    --rm -it \
    --net="none" \
    -v `pwd`:/tj3 \
    -u `id -u` \
    ${DOCKER_IMAGE} "$@"
