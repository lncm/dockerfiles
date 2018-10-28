#!/bin/bash

exec > /home/pi/service-check.log 2>&1
set -x

# Check IP Addresses and update if broken
IP=`ip route get 1 | awk '{print $NF;exit}'`
if [ ! -f /home/pi/ipaddress.txt ]; then
    echo $IP > /home/pi/.ipaddress.txt
else
    OLDIP=$(cat /home/pi/.ipaddress.txt)
    if [ ! $OLDIP == $IP ]; then
        echo "IP Address is different"
        # IP Address is different, Update the configs
        sed "s/$OLDIP/$IP/g; " /home/pi/data/lightningd/config > /home/pi/data/lightningd/config
        # Update the IP Addresses
        echo $IP > /home/pi/.ipaddress.txt
    fi
fi

while [ 1 ]
do

	# Check for bitcoind
	if $(nc -z -v -w5 $IP 8332); then
		echo "Bitcoind is alive"
	else
		echo "Starting up bitcoind"
		docker run --rm \
			-v /home/pi/data:/data \
			-p 8332:8332 \
			-p 8333:8333 \
			-p 28332:28332 \
			-p 28333:28333 \
			--name beyourownbank \
			-d=true \
		lncm/bitcoind:0.17.0-arm7
	fi

	# Check for lightningd
	if $(nc -z -v -w5 $IP 9735); then
		echo "Lightning service is online"
	else
		echo "Starting up lightning service because offline"
		docker run -it --rm \
			--entrypoint="/data/ln.sh" \
			-v /home/pi/data:/data \
			-v /home/pi/data/lightningd:/root/.lightning \
			-p 9735:9735 \
			-d=true \
			--name lightningpay \
		lncm/clightning:0.6.1-arm7
	fi
	# Check every 20 seconds
	sleep 20
done
