#!/bin/sh

# This script builds the official lnd container and tags it to whatever VER is set to

VER=latest

# for alpine
if [ $(. /etc/os-release; echo "$ID") == 'raspbian' ]; then
    apt-get install -y git
elif [ $(. /etc/os-release; echo "$ID") == 'alpine' ]; then
    apk add git
else
    echo 'Can not determine system''
fi


git clone https://github.com/lightningnetwork/lnd.git
cd lnd
docker build ./ > /tmp/docker_build.txt
image=$(tail -n 1 /tmp/docker_build.txt | cut -d " " -f 3)
docker tag $image lncm/lnd:${VER}
