FROM lncm/bitcoind:0.17.0-alpine-arm7
MAINTAINER nolim1t <hello@nolim1t.co>

WORKDIR /source
RUN cd /source

# Install Lightning dependencies
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add build-base

RUN apk --no-cache add gmp-dev
RUN apk --no-cache add sqlite-dev
RUN apk --no-cache add python3
RUN apk --no-cache add python
RUN apk --no-cache add net-tools
RUN apk --no-cache add zlib-dev

RUN apk --no-cache add git

RUN apk --no-cache add libtool

ENV PATH=/bin:/usr/local/bin:/opt/bitcoin-0.17.0/bin:/usr/bin:$PATH

# Build lightningd
RUN git clone https://github.com/ElementsProject/lightning.git
WORKDIR /source/lightning
RUN cd /source/lightning
RUN git checkout v0.6.1
RUN ./configure
RUN make
RUN make install
# lightningd build


EXPOSE 9735

# Run bitcoind where we built it
# $RPCUSER, $RPCPASSWORD, $RPCHOST
CMD ["/usr/local/bin/lightningd", "--lightning-dir=/data/lightningd"]
