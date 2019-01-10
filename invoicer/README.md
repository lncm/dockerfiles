# Invoicer Dockerfile

## Building

### Copy static file

Make directory called ```static``` and then copy index.html and any static assets there

### Run build command

```bash
docker build -t lncm/invoicer:VERSION-arm .
```

## Running

```bash
# Latest version
docker run --rm -v $HOME/.lnd:/lnd lncm/invoicer:
latest-arm

# Specific versions (for better stability and control)
# v0.0.11
docker run --rm -v $HOME/.lnd:/lnd lncm/invoicer:v0.0.11-arm 
```
