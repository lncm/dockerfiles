# c-lightning / lightningd sqlite3 database (MAINNET)

## What block is this up to?

This sqlite3 database is to bootstrap the install for c-lightning so its all up to data. 

This is highly experimental right now, so don not have any real money on your lightningd node when you start doing this.

## Usage

```bash
wget "https://github.com/lncm/dockerfiles/blob/master/contrib/lightningd-database/lightningd.sqlite3.gz?raw=true" -O lightningd.sqlite3.gz
gzip -d lightningd.sqlite3.gz
# Or copy to another place where your lightningd directory lives
cp lightningd.sqlite3 ~/.lightning
```

## Preparing the database for distribution

Basically we only want the blocks folder, all other stuff can be discarded.

```bash
lightning-cli stop
sqlite3 /path/to/lightningd.sqlite3

# In SQLITE
delete from transactions;
delete from utxoset_spend;
delete from utxoset;
delete from channel_htlcs;
delete from channels;
```