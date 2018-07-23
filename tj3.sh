#!/bin/sh

docker run \
    --rm -it \
    --net="none" \
    -v `pwd`:/tj3 \
    -u `id -u` \
    tj3:local "$@"

# vim:fdm=marker:ts=4:sw=4:sts=4:ai:sta:et
