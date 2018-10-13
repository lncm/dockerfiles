# c-lightning / lightningd sqlite3 database

## What block is this up to?

This sqlite3 database is to bootstrap the install for c-lightning so its all up to data.

## Usage

```bash
wget "https://github.com/lncm/dockerfiles/blob/master/contrib/lightningd-database/lightningd.sqlite3.gz?raw=true" -O lightningd.sqlite3.gz
gzip -d lightningd.sqlite3.gz
# Or copy to another place where your lightningd directory lives
cp lightningd.sqlite3 ~/.lightning
```
