# Config generator

## What

Generates a **bitcoin.conf** (to be copied to .bitcoin/bitcoin.conf), **lightningconfig** (to be renamed/copied to .lightning/config), and **lnd.conf** (to be copied to .lnd/lnd.conf). With randomly generated RPC credentials so that the services can talk with each other.

## Dependencies

### Raspbian/Ubuntu

* apt install pwgen

### Alpine Linux

* apk add curl
* apk add pwgen
* apk add python

## Usage


```bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/config-generator/generate-config.sh" 2>/dev/null | bash
```

or 

```bash
curl "https://raw.githubusercontent.com/lncm/dockerfiles/master/contrib/config-generator/generate-config.sh" 2>/dev/null | bash
```
