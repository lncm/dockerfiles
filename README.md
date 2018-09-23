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

From the project root, e.g.:
```bash
cd dockerfiles
```

This builds **bitcoind** and for **lncm/bitcoind** repo. Please tag your uploads according to `<version>-<arch>` where `version` is of the form `0.16.3` and `arch` may take `x64`, `arm6` or `arm7` depending to the CPU you are building on.

**Bitcoin Core (bitcoind) for Linux**
```bash
# x86_64 (64-bit)
docker build -t lncm/bitcoind:unversioned-x64 ./bitcoind/x86_64
# ARMv6 (32-bit Raspberry Pi: 1 / 1+ / 2 / Zero) 
docker build -t lncm/bitcoind:unversioned-arm6 ./bitcoind/arm
# ARMv7 (64-bit Raspberry Pi: 2 v1.2 / 3 / 3+)
docker build -t lncm/bitcoind:unversioned-arm7 ./bitcoind/arm
```

### Downloading

Grab from docker hub if you don't have the image and don't want to spend hours compiling

**Bitcoin Core (bitcoind) for Linux**
```bash
# x86_64 (64-bit PC)
docker pull lncm/bitcoind:0.16.3-x64

# ARMv6 (32-bit Raspberry Pi: 1 / 1+ / 2 / Zero)
docker pull lncm/bitcoind:0.16.3-arm6

# ARMv7 (64-bit Raspberry Pi: 2 v1.2 / 3 / 3+)
docker pull lncm/bitcoind:0.16.3-arm7
```
**c-lightning (lightningd) for Linux**
```bash
# x86_64 (64-bit PC)
docker pull lncm/clightning:0.16.3-x64

# ARMv6 (32-bit Raspberry Pi: 1 / 1+ / 2 / Zero)
docker pull lncm/clightning:0.6.1-arm6

# ARMv7 (64-bit Raspberry Pi: 2 v1.2 / 3 / 3+)
docker pull lncm/clightning:0.6.1-arm7
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
-d=true \
lncm/bitcoind:0.16.3-x86_64
```

Basically the above maps a local folder to data. This stores the bitcoin.conf which should be in a folder called **/btc** inside the data folder. Will try to simplify this later.

#### Windows
 ```
docker run --rm -v drive:\data\:/data -p 8333:8333 -p 8332:8332 --name beyourownbank -d=true lncm/bitcoind:0.16.3-x86_64
```

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

## Debugging containers

This is highly developmental so it may break. But it can be quite useful to include debug information into bug reports.

To peak into the container:

```bash
docker commit last-container-id-that-crashed
docker run -it new-container-id
```

You should be able to execute

## Conclusion

![buy btc](https://gitlab.com/nolim1t/financial-independence/raw/62573d151635e0170711bd9a7d45bb7e93299e2a/buybtc.png)

