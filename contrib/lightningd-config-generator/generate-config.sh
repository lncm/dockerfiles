if command -v pwgen 2>&1 1>/dev/null; [ "$?" -ne "0" ]; then
  echo "'pwgen' is needed by functions within this script. If you're on Debian-based system, you can install it with:"
  echo "	sudo apt install pwgen"
  exit 1
fi

# Execute
GENERATEDUID=`pwgen -s 12 1` # This can be used in for for subsequent scripts
GENERATEDPW=`pwgen -s 16 1` # This can be used in for for subsequent scripts

echo "Generating RPC Auth from bitcoin repo"
curl "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" 2>/dev/null 1>rpcauth.py
if [ -f ./rpcauth.py ]; then
	chmod 700 rpcauth.py
	./rpcauth.py $GENERATEDUID $GENERATEDPW | head -2 | tail -1 > generate.txt
	rm rpcauth.py
else
	echo "rpcauth.py not generated - could not reach server"
	exit 1
fi

if [ -f ./generate.txt ]; then
	RPCAUTHLINE=`cat ./generate.txt`
	cat <<EOF >./bitcoin.conf
server=1
rest=1
rpcallowip=127.0.0.1
rpcallowip=192.168.0.1/24
rpcallowip=192.168.1.1/24
rpcallowip=10.0.0.0/8
rpcallowip=172.16.0.0/12
rpcallowip=172.18.0.0/16


maxmempool=512
prune=550
maxconnections=40
maxuploadtarget=5000
disablewallet=1

listen=1
bind=0.0.0.0

port=8333
rpcport=8332
$RPCAUTHLINE
EOF

	IPADDRESS=`ip route get 1 | awk '{print $NF;exit}'`
	echo "$IPADDRESS" > $HOME/.ipaddress.txt
	PROXY="$(echo $IPADDRESS):9050"
	NODEALIAS='LNCM BOX Default #reckless'

	cat <<EOF >./lightningconfig
network=bitcoin
alias=$NODEALIAS
rgb=000000
mainnet
rpc-file=/data/lightningd/lightning-rpc

bitcoin-rpcconnect=$IPADDRESS
bitcoin-rpcport=8332
bitcoin-rpcuser=$GENERATEDUID
bitcoin-rpcpassword=$GENERATEDPW
bitcoin-datadir=/data/btc
bitcoin-cli=/usr/local/bitcoin/bin/bitcoin-cli

log-level=debug
log-file=/data/lightningd/debug.log

proxy=$PROXY

# Clean up 2 hours old invoices
autocleaninvoice-cycle=7200
autocleaninvoice-expired-by=7200
EOF
	# Cleanup
	rm ./generate.txt
	echo "Generated config file - bitcoin.conf and lightningconfig"
else
	echo "Could not generate a config file"
	exit 1
fi
