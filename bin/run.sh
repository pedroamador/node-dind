#!/bin/sh

VERSION=$1

docker run \
--privileged \
--name node-dind \
-p 3000:3000 \
--rm \
-d \
redpandaci/node-dind:$VERSION