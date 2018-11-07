FROM library/alpine:3.6
MAINTAINER nolim1t <hello@nolim1t.co>


# Install dependencies (boost/zmq)
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add boost-dev
RUN apk --no-cache add build-base
RUN apk --no-cache add chrpath
RUN apk --no-cache add file
RUN apk --no-cache add gnupg
RUN apk --no-cache add libevent-dev
RUN apk --no-cache add libressl
RUN apk --no-cache add libressl-dev
RUN apk --no-cache add libtool
RUN apk --no-cache add linux-headers
RUN apk --no-cache add protobuf-dev
RUN apk --no-cache add zeromq-dev
RUN apk add --no-cache jq
RUN apk add --no-cache pwgen
RUN apk add --no-cache libboost-all-dev
RUN apk add --no-cache git
RUN apk add --no-cache wget
RUN apk add --no-cache unzip


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
RUN ./configure BDB_LIBS="-L/source/bitcoin/db4/lib -ldb_cxx-4.8" BDB_CFLAGS="-I/source/bitcoin/db4/include" --with-boost-libdir=/usr/lib/x86_64-linux-gnu --without-gui --disable-wallet --prefix=/usr/local/bitcoin --disable-tests --disable-bench
RUN make -j1
RUN make install
# Bitcoind Built

# More for debugging
RUN apt-get install -yq netcat

# Expose ports 8333 (RPC), and 8332 (P2P) and zmq ports
EXPOSE 8332 8333 28332 28333

# Run bitcoind where we built it
CMD ["/usr/local/bitcoin/bin/bitcoind","-datadir=/data/btc", "-zmqpubrawblock=tcp://0.0.0.0:28332", "-zmqpubrawtx=tcp://0.0.0.0:28333"]
