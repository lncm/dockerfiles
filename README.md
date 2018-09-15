# Financial Independence Docker build

## What

This docker file installs all the dependencies and bitcoind, then runs it.

Idea behind this is to have a easy configurable bitcoind in a secure fashion.

Eventually, I'd want to incorporate lightningd too, maybe doing a compose file.

## Building / BUIDL

From the project root

```bash
docker build -t nolim1t/mini-bitcoind ./bitcoind
```

## Starting

### Bitcoind

```bash
docker run -v /local/path/to/data:/data \
-p 8334:8332 \
-p 8335:8333 \
--name beyourownbank \
-d=true nolim1t/mini-bitcoind
```

Basically the above maps a local folder to data. This stores the bitcoin.conf which should be in a folder called **/btc** inside the data folder. Will try to simplify this later.

Also maps RPC to 8334 and P2P to 8335

## Stopping

```bash
docker stop beyourownbank
docker rm beyourownbank
```

This stops and cleans up the service.

## Conclusion

![buy btc](https://gitlab.com/nolim1t/financial-independence/raw/62573d151635e0170711bd9a7d45bb7e93299e2a/buybtc.png)

