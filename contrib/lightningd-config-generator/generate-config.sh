#!/bin/bash


IPADDRESS=`ip route get 1 | awk '{print $NF;exit}'`
PROXY="$(echo $IPADDRESS):9050"
NODEALIAS='default #reckless'
BTCUSERNAME='username'
BTCPASSWORD='password'
if [ -d /home/pi/data ]; then
	if [ -d /home/pi/data/lightningd ]; then
		if [ ! -f /home/pi/data/lightningd/config ]; then	
			echo \
"network=bitcoin
alias=$NODEALIAS
rgb=000000
mainnet
rpc-file=/data/lightningd/lightning-rpc

bitcoin-rpcconnect=$IPADDRESS
bitcoin-rpcport=8332
bitcoin-rpcuser=$BTCUSERNAME
bitcoin-rpcpassword=$BTCPASSWORD
bitcoin-datadir=/data/btc
bitcoin-cli=/usr/local/bitcoin/bin/bitcoin-cli

log-level=debug
log-file=/data/lightningd/debug.log

proxy=$PROXY
# 1 sat base
fee-base=1000
# 0.1337% of the payment
fee-per-satoshi=1337

# Clean up 2 hours old invoices
autocleaninvoice-cycle=7200
autocleaninvoice-expired-by=7200
" > /home/pi/data/lightningd/config
		else
			echo "config alread exists!"
		fi
	fi
fi
