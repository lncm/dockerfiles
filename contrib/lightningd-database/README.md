# c-lightning / lightningd sqlite3 database (MAINNET)

## What block is this up to?

This sqlite3 database is to bootstrap the install for c-lightning up to block **#546651**

This is highly experimental right now, so don not have any real money on your lightningd node when you start doing this.

## Usage

```bash
wget "https://github.com/lncm/dockerfiles/blob/master/contrib/lightningd-database/lightningd.sqlite3.gz?raw=true" -O lightningd.sqlite3.gz
gzip -d lightningd.sqlite3.gz
# Or copy to another place where your lightningd directory lives
cp lightningd.sqlite3 ~/.lightning
```

## Preparing the database for distribution (for future blocks)

Basically we only want the blocks folder, all other stuff can be discarded.

```bash
lightning-cli stop
cp /home/pi/data/lightningd/lightningd.sqlite3 /home/pi

# In Cleaning up the database
sqlite3 /home/pi/lightningd.sqlite3 "delete from channels; delete from transactions; delete from invoices; delete from utxoset; delete from channel_htlcs; delete from payments; delete from outputs; "
# Set the amount of addreesses to be generated
sqlite3 /home/pi/lightningd.sqlite3 "update vars set val = 1 where name = 'bip32_max_index'; "

# One Liner (executed from /home/pi)

docker exec -it lightningpay lightning-cli stop ; sleep 10 ; cp /home/pi/data/lightningd/lightningd.sqlite3 /home/pi ; sqlite3 /home/pi/lightningd.sqlite3 "delete from channels; delete from transactions; delete from invoices; delete from utxoset; delete from channel_htlcs; delete from payments; delete from outputs; update vars set val = 1 where name = 'bip32_max_index'; " ; sleep 10 ; docker run -it --rm --entrypoint="/data/ln.sh" -v /home/pi/data:/data -v /home/pi/data/lightningd:/root/.lightning -p 9735:9735 -d=true --name lightningpay lncm/clightning:0.6.1-arm7 ; gzip lightningd.sqlite3 ; mv lightningd.sqlite3.gz source/financial-independance/contrib/lightning-database ; cd source/financial-independance ; git commit -am "Update lightning database"  ; git push origin master

```
