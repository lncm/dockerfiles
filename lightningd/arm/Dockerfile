FROM lncm/bitcoind:0.17.0-arm7
MAINTAINER nolim1t <hello@nolim1t.co>

WORKDIR /source
RUN cd /source

# Install Lightning dependencies
RUN apt-get install -y autoconf automake build-essential git libtool libgmp-dev libsqlite3-dev python python3 net-tools zlib1g-dev

# Build lightningd
RUN git clone https://github.com/ElementsProject/lightning.git
WORKDIR /source/lightning
RUN cd /source/lightning
RUN git checkout v0.6.1
RUN ./configure
RUN make
RUN make install
# lightningd build

# bitcoin-cli path = /usr/local/bitcoin/bin/bitcoin-cli

EXPOSE 9735

RUN export PATH=/usr/local/bin:/usr/local/bitcoin/bin

# Run bitcoind where we built it
# $RPCUSER, $RPCPASSWORD, $RPCHOST
CMD ["/usr/local/bin/lightningd", "--lightning-dir=/data/lightningd"]



