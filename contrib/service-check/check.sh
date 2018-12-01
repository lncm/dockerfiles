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
			if [ $(docker ps | grep -c beyourownbank) == 1 ]; then
				if $(nc -z -v -w5 $IP 8332); then
					echo "Bitcoind is fully alive"
				else
					echo "Bitcoind is alive but not responding to requests"
				fi
			else
				echo "Starting up bitcoind"
				if [ $(uname -m) == "armv7l" ]; then
					echo "ARM system detected"
					docker run -it --rm \
						-v $HOME/data/btc:/home/bitcoin/.bitcoin \
						-v $HOME/data/btc:/root/.bitcoin \
						-p 0.0.0.0:8332:8332 \
						-p 0.0.0.0:8333:8333 \
						-p 0.0.0.0:28332:28332 \
						-p 0.0.0.0:28333:28333 \
						--name beyourownbank \
						-d=true \
            lncm/bitcoind:0.17.0-alpine-arm7
				elif [ $(uname -m) == "x86_64" ]; then
					echo "x86_64 system detected"
					docker run --rm \
						-v $HOME/data:/data \
						-p 8332:8332 \
						-p 8333:8333 \
						-p 28332:28332 \
						-p 28333:28333 \
						--name beyourownbank \
						-d=true \
					lncm/bitcoind:0.17.0-x64
				else
					echo "System Architecture not supported"
				fi
			fi
		fi

		# Check for lightningd - If directory Exists
		if [ -d $HOME/data/lightningd ]; then
			# Also check if the entrypoint file exists
			if [ -f $HOME/data/ln.sh ]; then
				if [ $(docker ps | grep -c lightningpay) == 1 ]; then
					if $(nc -z -v -w5 $IP 9735); then
						echo "Lightningd is fully alive"
					else
						echo "Lightningd is alive but not responding to requests yet"
					fi
				else
					echo "Lightningd is offline - starting"
					if [ $(uname -m) == "armv7l" ]; then
						echo "ARM system detected"
						docker run -it --rm \
						  -v $HOME/data:/data \
						  -v $HOME/data/lightningd:/root/.lightning \
						  -p 0.0.0.0:9735:9735 \
						  -d=true \
						  --entrypoint="/data/ln.sh" \
						  --name lightningpay \
						lncm/clightning:0.6.1-alpine-arm7
					elif [ $(uname -m) == "x86_64" ]; then
						echo "x86_64 system detected"
						docker run -it --rm \
							--entrypoint="/data/ln.sh" \
							-v $HOME/data:/data \
							-v $HOME/data/lightningd:/root/.lightning \
							-p 9735:9735 \
							-d=true \
							--name lightningpay \
						lncm/clightning:0.6.1-x64
					else
						echo "System architecture not supported"
					fi
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
					if $(nc -z -v -w5 $IP 8333); then
						echo "Bitcoind is running"
					else
						echo "Bitcoind is dead, start it up"
						# Start bitcoind
						bitcoind -daemon -zmqpubrawblock=tcp://0.0.0.0:28332 -zmqpubrawtx=tcp://0.0.0.0:28333
					fi
				fi
			fi
		else
			echo "No bitcoind exists"
		fi

		# Check for lightningd
		if command -v lightningd 2>&1 1>/dev/null; [ "$?" -eq "0" ]; then
			if [ -d $HOME/.lightning ]; then
				echo "We have a lightning directory"
				if [ -f $HOME/.lightning/config ]; then
					if $(nc -z -v -w5 $IP 9735); then
						echo "Something is running on 9735 - not running lightning"
					else
						lightningd -daemon
					fi
				else
					echo "Lightningd not configured - skipping"
				fi
			else
				echo "Lightningd not configured (no directory called .lightning) - skipping"
			fi
		fi

		# Check LND
		if [ ! -z "$GOPATH" ]; then
			if [ -f $GOPATH/bin/lnd ]; then
				if [ -f $HOME/.lnd/lnd.conf ]; then
					if command -v lnd 2>&1 1>/dev/null; [ "$?" -eq "0" ]; then
						echo "LND exists and is configured"
						# TODO: run lnd without unlocking or create wallet bullshit when I figure that out
					fi
				else
					echo "LND not configured skipping"
				fi
			fi
		else
			echo "GOPATH not set so there is no LND isntalled"
		fi
	fi
	# Check every 60 seconds
	sleep 60
done
