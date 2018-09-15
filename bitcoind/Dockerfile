FROM library/ubuntu:16.04
MAINTAINER nolim1t <hello@nolim1t.co>

# Install dependencies
RUN apt-get -y -yqq update
RUN apt-get -yq upgrade
RUN apt-get install -yq build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev
RUN apt-get install -yq jq
RUN apt-get install -yq pwgen
RUN apt-get install -yq libboost-all-dev
RUN apt-get -y -yqq install git
RUN apt-get -y -yqq install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get -y -yqq update
# Lets cheat a little
RUN apt-get install -yq bitcoind
# More for debugging
RUN apt-get install -yq netcat

# Expose ports 8332, and 8333
EXPOSE 8332 8333

# Run bitcoind
CMD ["/usr/bin/bitcoind","-datadir=/data/btc"]
