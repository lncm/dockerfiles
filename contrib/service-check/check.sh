#!/bin/bash

if [ -d /home/pi ]; then
	exec > /home/pi/service-check.log 2>&1
	set -x	
else
	exec > $HOME/service-check.log 2>&1
	set -x
fi

# Check IP Addresses and update if broken (PI specific)
IP=`ip route get 1 | awk '{print $NF;exit}'`
echo "Update IP Address script"
if [ ! -f /home/pi/.ipaddress.txt ]; then
    echo "IP Address doesnt exist in file"
    echo $IP > /home/pi/.ipaddress.txt
else
    OLDIP=$(cat /home/pi/.ipaddress.txt)
    if [ ! $OLDIP == $IP ]; then
        echo "IP Address is different"
        # IP Address is different, Update the configs
        cp /home/pi/data/lightningd/config /home/pi/data/lightningd/config.old
        sed "s/$OLDIP/$IP/g; " /home/pi/data/lightningd/config > /home/pi/data/lightningd/config.new
        cp /home/pi/data/lightningd/config.new /home/pi/data/lightningd/config
        # Update the IP Addresses
        echo $IP > /home/pi/.ipaddress.txt
    fi
fi

while [ 1 ]
do

	# Check for docker
	echo "Checking existance of docker"
	if  [ -f /usr/bin/docker ]; then
		# OK Docker exists
		# Check for bitcoind - if data directory exists
		if [ -d $HOME/data/btc ]; then
			if $(nc -z -v -w5 $IP 8332); then
				echo "Bitcoind is alive"
			else
				echo "Starting up bitcoind"
				docker run --rm \
					-v $HOME/data:/data \
					-p 8332:8332 \
					-p 8333:8333 \
					-p 28332:28332 \
					-p 28333:28333 \
					--name beyourownbank \
					-d=true \
				lncm/bitcoind:0.17.0-arm7
			fi	
		fi

		# Check for lightningd - If directory Exists
		if [ -d $HOME/data/lightningd ]; then
			# Also check if the entrypoint file exists
			if [ -f $HOME/data/ln.sh ]; then
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
			fi	
		fi	
	else
		echo "Docker does not exist"
		# try to launch other ways
		# Check if bitcoind exists
		if command -v bitcoind 2>&1 1>/dev/null; [ "$?" -eq "0" ]; then
			echo "Bitcoind exists on the machine, lets try to start it"
			if [ -d $HOME/.bitcoin ]; then
				if [ -f $HOME/.bitcoin/bitcoin.conf ]; then
					# Start bitcoind
					bitcoind -daemon				
				fi
			fi
		else
			echo "No bitcoind exists"
		fi
		# Check LND
		if [ ! -z "$GOPATH" ]; then
			if [ -f $GOPATH/bin/lnd ]; then
				if [ -f $HOME/.lnd/lnd.conf ]; then
					echo "LND exists and is configured"				
				fi
			fi
		else
			echo "GOPATH not set so there is no LND isntalled"
		fi
	fi
	# Check every 60 seconds
	sleep 60
done
