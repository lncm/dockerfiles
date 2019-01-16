#!/bin/sh

if [ -z $BOXNAME ]; then
    BOXNAME='compose_invoicerbox_1'
fi

if command -v docker 2>&1 1>/dev/null; [ "$?" -ne "0" ]; then
    echo "Docker is not installed"
    exit 1
fi

if command -v jq 2>&1 1>/dev/null; [ "$?" -ne "0" ]; then
    echo "jq is not installed"
    exit 1
fi
if [ "$(id -u)" -ne "0" ]; then
    echo "This tool must be run as root"
    exit 1
fi

if [ $(docker inspect $BOXNAME | jq '.[0].State.Health.Status' | sed 's/"//g; ') == "healthy" ]; then
    echo "OK"
    exit 0
else
    echo "Attempting to restart $BOXNAME"
    docker stop $BOXNAME
    docker start $BOXNAME
    exit 0
fi

