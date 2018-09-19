# Financial Independence Docker build

![Irrelephant](https://gitlab.com/nolim1t/financial-independence/raw/master/irrelephant.png)

## What

This docker file installs all the dependencies and bitcoind, then runs it.

Idea behind this is to have a easy configurable bitcoind almost as an easy install.

Eventually, I'd want to incorporate [lightningd](https://github.com/ElementsProject/lightning) or [LND](https://github.com/lightningnetwork/lnd) too, maybe doing a compose file.

## Cleanup all images

Make sure there is NOTHING running before you cleanup. 

From the project root

```bash
./clean.sh
```

OR if you don't have this project

```bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/clean.sh" 2>/dev/null | sh
```

## Building / BUIDL

From the project root. This builds whatever is in the folder **bitcoind** and tags it as **nolim1t/mini-bitcoind** (you may change this tag by the way, however it doesn't matter unless you plan to push to docker hub. In all open source spirit, please share your code if you do. Thanks)

```bash
# x86 bitcoind
docker build -t nolim1t/mini-bitcoind ./bitcoind/x86_64
# Arm
docker build -t nolim1t/mini-bitcoind ./bitcoind/arm

# Lightningd
docker build -t nolim1t/lightningd ./lightningd
```

OR

Grab from docker hub if you don't have the image and don't want to spend hours compiling

```bash
# if x86 Arch
docker pull nolim1t/mini-bitcoind:x86_64_201809151809
docker pull nolim1t/lightningd:x86_64-201809161814

# If ARM 64 Architecture (raspberry pi)
docker pull nolim1t/mini-bitcoind:arm_2018091801

# LND ARM64
docker pull nolim1t/lnd:latest-arm64
```

## Starting

### Bitcoind

```bash
# For x86 Architecture

docker run --rm \
-v /local/path/to/data:/data \
-p 8332:8332 \
-p 8333:8333 \
--name beyourownbank \
-d=true nolim1t/mini-bitcoind:x86_64_201809151809
```

Basically the above maps a local folder to data. This stores the bitcoin.conf which should be in a folder called **/btc** inside the data folder. Will try to simplify this later.

## Interactive shell

```bash
docker exec -it beyourownbank bash
```

## Stopping

```bash
docker stop beyourownbank
docker rm beyourownbank
```

This stops and cleans up the service.

## Debugging comtainers

This is highly developmental so it may break. But it can be quite useful to include debug information into bug reports.

To peak into the container:

```bash
docker commit last-container-id-that-crashed
docker run -it new-container-id
```

You should be able to execute

## Conclusion

![buy btc](https://gitlab.com/nolim1t/financial-independence/raw/62573d151635e0170711bd9a7d45bb7e93299e2a/buybtc.png)

