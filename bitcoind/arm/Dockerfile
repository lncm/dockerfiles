FROM library/ubuntu:18.10
MAINTAINER nolim1t <hello@nolim1t.co>


# Install dependencies (boost/zmq)
RUN apt-get -y -yqq update
RUN apt-get -yq upgrade
RUN apt-get install -yq build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libzmq3-dev jq pwgen libboost-all-dev git software-properties-common wget unzip autoconf automake libzmq3-dev


# Grab and build bitcoin
RUN cd /
RUN mkdir source
WORKDIR /source
RUN git clone https://github.com/bitcoin/bitcoin.git
RUN cd bitcoin
WORKDIR /source/bitcoin
RUN git checkout v0.17.0
# Install Bundled BDB from /source/bitcoin
RUN ./contrib/install_db4.sh /source/bitcoin
# Run Build script
RUN ./autogen.sh
RUN mkdir -p /usr/local/bitcoin
RUN ./configure BDB_LIBS="-L/source/bitcoin/db4/lib -ldb_cxx-4.8" BDB_CFLAGS="-I/source/bitcoin/db4/include" --with-boost-libdir=/usr/lib/arm-linux-gnueabihf --without-gui --disable-wallet --prefix=/usr/local/bitcoin --disable-tests --disable-bench
RUN make -j1
RUN make install
# Bitcoind Built


# More for debugging
RUN apt-get install -yq netcat

# Expose ports 8333 (RPC), and 8332 (P2P) and zmq ports
EXPOSE 8332 8333 28332 28333

# Run bitcoind where we built it
CMD ["/usr/local/bitcoin/bin/bitcoind","-datadir=/data/btc", "-zmqpubrawblock=tcp://0.0.0.0:28332", "-zmqpubrawtx=tcp://0.0.0.0:28333"]
