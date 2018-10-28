# Service checker for PI services

This is a looping bash script which checks that the node is online

## Invocation

```bash
wget -O /usr/local/bin/check.sh "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh"
./usr/local/bin/check.sh &
```

or

```bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh" 2>/dev/null | bash & 2>/dev/null 1>/dev/null
```

OR

```bash
curl "https://raw.githubusercontent.com/lncm/dockerfiles/master/contrib/service-check/check.sh" 2>/dev/null | bash & 2>/dev/null 1>/dev/null
```


## Put it into a system service

This will install the system checker into the crontab.

The service will also re-configure lightningd if the IP address of the box has changed upon startup.

### Run as root

```bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/install.sh" 2>/dev/null | sudo bash
```
OR

```bash
curl "https://raw.githubusercontent.com/lncm/dockerfiles/master/contrib/service-check/install.sh" 2>/dev/null | sudo bash
```

### Commands

```bash
# Or you can put
# curl "https://raw.githubusercontent.com/lncm/dockerfiles/master/contrib/service-check/check.sh" 2>/dev/null | bash & 2>/dev/null 1>/dev/null
# into the checkd file too, so it will always run the latest version.
cat <<EOF > /usr/local/bin/checkd.sh
#!/bin/bash
/usr/local/bin/check.sh & 2>/dev/null 1>/dev/null
EOF
chmod 755 /usr/local/bin/checkd.sh

# If you put the curl invocation, you can skip these two
wget -O /usr/local/bin/check.sh "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh"
chmod 755 /usr/local/bin/check.sh


# Set up system service
cat <<EOF >  /etc/systemd/system/paymentprocessor.service
[Unit]
Description=Payment Processor Service
After=network.target
ConditionPathExists=/usr/local/bin/checkd.sh
ConditionPathExists=/usr/local/bin/check.sh
ConditionPathExists=/home/pi/data/btc
ConditionPathExists=/home/pi/data/btc/bitcoin.conf
ConditionPathExists=/home/pi/data/btc/chainstate
ConditionPathExists=/home/pi/data/btc/blocks
ConditionPathExists=/home/pi/data/lightningd
ConditionPathExists=/home/pi/data/lightningd/config
ConditionPathExists=/usr/bin/docker
ConditionPathExists=/usr/bin/curl

[Service]
ExecStart=/usr/local/bin/checkd.sh
User=pi
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
systemctl enable paymentprocessor
```
