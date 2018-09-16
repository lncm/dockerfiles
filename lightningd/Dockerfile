FROM library/ubuntu:16.04
MAINTAINER nolim1t <hello@nolim1t.co>

# This maybe different if building on another CPU
# on RPI change this to /usr/lib/arm-linux-gnueabihf
ENV BOOSTDIR /usr/lib/x86_64-linux-gnu

RUN apt-get -y -yqq update
RUN apt-get -yq upgrade
RUN apt-get install -yq build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libzmq3-dev jq pwgen libboost-all-dev git software-properties-common wget unzip autoconf automake libzmq3-dev
RUN apt-get install -yq autoconf automake build-essential git libtool libgmp-dev libsqlite3-dev python python3 net-tools zlib1g-dev 

# Build and Install Berkley DB 4.8.30
RUN cd /
RUN mkdir source
RUN cd source
WORKDIR /source
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
RUN tar -xzvf db-4.8.30.NC.tar.gz
RUN cd db-4.8.30.NC
WORKDIR /source/db-4.8.30.NC
RUN cd build_unix
WORKDIR /source/db-4.8.30.NC/build_unix
RUN ../dist/configure --enable-cxx --prefix=/usr/local --enable-cxx
RUN make
RUN make install
# Finish building this
WORKDIR /source
RUN cd /source

# Grab and build bitcoin
RUN git clone https://github.com/bitcoin/bitcoin.git
RUN cd bitcoin
WORKDIR /source/bitcoin
RUN git checkout v0.16.2
RUN ./autogen.sh
RUN mkdir -p /usr/local/bitcoin
RUN ./configure CPPFLAGS="-I/usr/local/BerkeleyDB.4.8/include -O2" LDFLAGS="-L/usr/local/BerkeleyDB.4.8/lib" --with-boost-libdir=$BOOSTDIR --without-gui --disable-wallet --prefix=/usr/local/bitcoin --disable-tests --disable-bench
RUN make -j1
RUN make install
# Bitcoind Built

WORKDIR /source
RUN cd /source

# Build lightningd
RUN git clone https://github.com/ElementsProject/lightning.git
WORKDIR /source/lightning
RUN cd /source/lightning
RUN ./configure
RUN make
RUN make install
# lightningd build

# bitcoin-cli path = /usr/local/bitcoin/bin/bitcoin-cli

EXPOSE 9735

RUN export PATH=/usr/local/bin:/usr/local/bitcoin/bin

# Run bitcoind where we built it
# $RPCUSER, $RPCPASSWORD, $RPCHOST
CMD ["/usr/local/bin/lightningd", "--lightning-dir=/data/lightning"]



