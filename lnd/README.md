# LND Docker file

This script builds official [Lightning Labs LND](https://github.com/lightningnetwork/lnd/) container for Docker.

Tested to work on Alpine ARM.

## Official Dockerfile Instructions

### Building

Requires docker and git
```bash
chmod +x build_lnd.sh
./build_lnd.sh
```

### Docker Run

#### Fetching

```docker
docker pull lncm/lnd:latest
```

#### Running

```docker
docker run -v /root/lnd_data:/lnd --network host --rm -it lncm/lnd:latest
```
