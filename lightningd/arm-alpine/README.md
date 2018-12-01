# C-lightning docker container

## Invocation

```bash
docker pull lncm/clightning:0.6.1-alpine-arm7

# Copy entrypoint
mkdir ~/data
cp ../../ln.sh ~/data

# lncm/clightning:0.6.1-alpine-arm7
docker run -it --rm \
  -v $HOME/data:/data \
  -v $HOME/data/lightningd:/root/.lightning \
  -p 0.0.0.0:9735:9735 \
  -d=true \
  --entrypoint="/data/ln.sh" \  
  --name lightningpay \
lncm/clightning:0.6.1-alpine-arm7
```
