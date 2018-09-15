# Financial Independence Docker build

![Irrelephant](https://gitlab.com/nolim1t/financial-independence/raw/master/irrelephant.png)

## What

This docker file installs all the dependencies and bitcoind, then runs it.

Idea behind this is to have a easy configurable bitcoind almost as an easy install.

Eventually, I'd want to incorporate [lightningd](https://github.com/ElementsProject/lightning) or [LND](https://github.com/lightningnetwork/lnd) too, maybe doing a compose file.

## Cleanup all images

From the project root

```bash
./clean.sh
```

## Building / BUIDL

From the project root. This builds whatever is in the folder **bitcoind** and tags it as **nolim1t/mini-bitcoind** (you may change this tag by the way, however it doesn't matter unless you plan to push to docker hub. In all open source spirit, please share your code if you do. Thanks)

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

