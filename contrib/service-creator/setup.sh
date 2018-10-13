#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
    echo "Please run this utility with sudo or root"
    exit 1
fi

if ! docker images | grep 0.17.0-arm7; then
    echo "Image doesnt exist - Downloading"
    docker pull lncm/bitcoind:0.17.0-arm7
fi

if [ -f /usr/bin/docker ]; then
    if [ -d /home/pi/data ]; then
        if [ -d /home/pi/data/btc ]; then
           if [ -f /home/pi/data/btc/bitcoin.conf ]; then
                cat <<EOF >  /etc/systemd/system/bitcoind.service
[Unit]
Description=Bitcoin daemon
After=network.target
ConditionPathExists=/home/pi/data/btc

[Service]
ExecStart=/usr/bin/docker run --rm -v /home/pi/data:/data -p 8332:8332 -p 8333:8333 -p 28333:28333 -p 28332:28332 --name beyourownbank -d=true lncm/bitcoind:0.17.0-arm7
User=pi
Type=forking
RemainAfterExit=true
ExecStop=/usr/bin/docker stop beyourownbank
PIDFile=/home/pi/data/btc/bitcoin.pid

[Install]
WantedBy=multi-user.target

EOF
                # Installed
                systemctl enable bitcoind
                echo "bitcoind service installed - to enable run 'sudo systemctl start bitcoind' or 'sudo systemctl status bitcoind' for the status"
                exit 0
            else
               echo "bitcoin.conf doesn't exist - aborting"
               exit 1
           fi
        else
            echo "btc directory doesnt exist in data dir - aborting"
            exit 1
        fi
    else
        echo "Data directory doesn't exist - aborting"
        exit 1
    fi
else
    echo "Docker doesn't exist, Not supported right now"
    exit 1
fi

