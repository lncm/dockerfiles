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

if [ $(grep -c $GENERATEDUID ./generate.txt ) == 0 ]; then
	echo "Can't generate credentials - exiting!"
	exit 1
fi

if [ -f ./generate.txt ]; then
	RPCAUTHLINE=`cat ./generate.txt`

	# Generate bitcoin configuration
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
prune=1500
maxconnections=40
maxuploadtarget=5000
disablewallet=1

listen=1
bind=0.0.0.0

port=8333
rpcport=8332
$RPCAUTHLINE
EOF

	# Generate Litecoin configuration
	cat <<EOF >./litecoin.conf
server=1
rest=1
rpcallowip=127.0.0.1
rpcallowip=192.168.0.1/24
rpcallowip=192.168.1.1/24
rpcallowip=10.0.0.0/8
rpcallowip=172.16.0.0/12
rpcallowip=172.18.0.0/16


maxmempool=512
prune=1500
maxconnections=40
maxuploadtarget=5000
disablewallet=1

listen=1
bind=0.0.0.0

port=9333
rpcport=9332
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
rpc-file=$HOME/.lightning/lightning-rpc

bitcoin-rpcconnect=$IPADDRESS
bitcoin-rpcport=8332
bitcoin-rpcuser=$GENERATEDUID
bitcoin-rpcpassword=$GENERATEDPW
bitcoin-datadir=/data/btc
bitcoin-cli=/opt/bitcoin-0.17.0/bin/bitcoin-cli

log-level=debug
log-file=$HOME/.lightning/debug.log

proxy=$PROXY

# Clean up 2 hours old invoices
autocleaninvoice-cycle=7200
autocleaninvoice-expired-by=7200
EOF
	# Generate lnd.conf (for docker installations)
	# To Query:
	# lncli --lnddir=~/.lnd --macaroonpath=~/.lnd/admin.macaroon getinfo
	cat <<EOF >./lnd.conf
[Application Options]

datadir=$HOME/.lnd/data
logdir=$HOME/.lnd/logs
maxlogfiles=3
maxlogfilesize=10

tlscertpath=$HOME/.lnd/tls.cert
tlskeypath=$HOME/.lnd/tls.key
noseedbackup=1

adminmacaroonpath=$HOME/.lnd/admin.macaroon
readonlymacaroonpath=$HOME/.lnd/readonly.macaroon
invoicemacaroonpath=$HOME/.lnd/invoice.macaroon


listen=0.0.0.0:9735
restlisten=0.0.0.0:8080
debuglevel=debug
alias=$NODEALIAS

[Bitcoin]
bitcoin.active=1
bitcoin.testnet=0
bitcoin.mainnet=1
bitcoin.node=bitcoind



[Bitcoind]
bitcoind.rpchost=$IPADDRESS:8332
bitcoind.rpcuser=$GENERATEDUID
bitcoind.rpcpass=$GENERATEDPW
bitcoind.zmqpubrawblock=tcp://$IPADDRESS:28332
bitcoind.zmqpubrawtx=tcp://$IPADDRESS:28333


EOF
	# Cleanup
	rm ./generate.txt
	echo "Generated config file - bitcoin.conf, lnd.conf and lightningconfig"
else
	echo "Could not generate a config file"
	exit 1
fi
