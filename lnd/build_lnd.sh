#!/bin/sh

# This script builds the official lnd container and tags it

VER=latest

# for alpine
apk add git


git clone https://github.com/lightningnetwork/lnd.git
cd lnd
docker build ./ > /tmp/docker_build.txt
image=$(tail -n 1 /tmp/docker_build.txt | cut -d " " -f 3)
docker tag $image lncm/lnd:${VER}
