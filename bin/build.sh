#!/bin/bash

VERSION=$1

docker build -t redpandaci/node-dind:$VERSION .