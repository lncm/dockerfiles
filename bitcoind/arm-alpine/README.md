# Alpine Dockerfile

## About

This dockerfile is based on [ruimarinho/docker-bitcoin-core](https://github.com/ruimarinho/docker-bitcoin-core/blob/master/0.17/alpine/Dockerfile) however its made to work for raspberry pi installs, and also has wallet disabled.

I've also removed the entrypoint has that has some issues, and replaced it to work without.

## Need a bitcoin config file?

Use one of my [scripts](https://gitlab.com/nolim1t/financial-independence/tree/master/contrib/lightningd-config-generator) or [scripts(1)](https://github.com/lncm/dockerfiles/tree/master/contrib/lightningd-config-generator) which generates a bitcoin.conf and matching lightning conf.


## Invocation

```bash
# Grab image (arm)
docker pull lncm/bitcoind:0.17.0-alpine-arm7

# Run image
# Set local bitcoin path
BITCOIN_PATH=/home/pi/data/btc

# Run image
docker run -it --rm \
    -v $BITCOIN_PATH:/home/bitcoin/.bitcoin \
    -p 8332:8332 \
    -p 8333:8333 \
    -p 28333:28333 \
    -p 28332:28332 \
    --name beyourownbank \
    -d=true \
    lncm/bitcoind:0.17.0-alpine-arm7
```

