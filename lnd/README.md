# LND Docker file

Not maintaining this dockerfile anymore, so please use the [Official Docker file](https://github.com/lightningnetwork/lnd/tree/master/docker/lnd)

## Official Dockerfile Instructions

### Docker Build

```bash
git clone https://github.com/lightningnetwork/lnd.git
cd lnd/docker
git checkout v0.5.1-beta
docker build -t nolim1t/lnd:official-0.5.1 .
```

### Docker Run

#### Fetching

```docker
docker pull nolim1t/lnd:official-0.5.1
```

#### Running

```docker
LNDPATH=$HOME/.lnd

docker run -it --rm \
  -v $LNDPATH:/root/.bitcoin \
  -e CHAIN=bitcoin \
  -e NETWORK=mainnet \
  -e RPCUSER=lightning \
  -e RPCPASS=lightningpass \
  -p 0.0.0.0:9735:9735 \
  -d=true \
  --name lndpay \
  nolim1t/lnd:official-0.5.1 --lnddir=/root/.lnd
```
