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
        # Check if BTC exists
        if [ -d /home/pi/data/btc ]; then
           if [ -f /home/pi/data/btc/bitcoin.conf ]; then
                # If all the pieces of bitcoin is there
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

[Install]
WantedBy=multi-user.target

EOF
                # Installed
                systemctl enable bitcoind
                # bitcoind installed
                # Check for lightningd (lets try to set it up)
                if [ -d /home/pi/data/lightningd ]; then
                    if [ -f /home/pi/data/lightningd/conf ]; then
                        # Yay! We got a configured lighting
                        LNENTRYPOINT=/home/pi/data/ln.sh
                        if [ ! -f $LNENTRYPOINT ]; then
                            cat <<EOF >$LNENTRYPOINT
#!/bin/bash

/usr/local/bin/lightningd --lightning-dir=/data/lightningd
EOF
                            chmod 755 $LNENTRYPOINT
                            # Set up LN Entrypoint
                            if ! docker images | grep 0.6.1-arm7; then
                                echo "LN Image doesnt exist - Downloading"
                                docker pull lncm/lncm/clightning:0.6.1-arm7
                            fi
                            # Create lightningd service
                            cat <<EOF >  /etc/systemd/system/lightningd.service
[Unit]
Description=C lightning daemon
After=network.target
ConditionPathExists=/home/pi/data/lightningd

[Service]
ExecStart=/usr/bin/docker run -it --rm --entrypoint="/data/ln.sh" -v /home/pi/data:/data -v /home/pi/data/lightningd:/root/.lightning -p 9735:9735 -d=true --name lightningpay lncm/clightning:0.6.1-arm7
User=pi
Type=forking
RemainAfterExit=true
ExecStop=/usr/bin/docker stop lightningpay

[Install]
WantedBy=multi-user.target
                            
EOF
                            # lightningd service created
                            systemctl enable lightningd
                            # output
                            echo "lightningd service installed - to enable run 'sudo systemctl start lightningd' or 'sudo systemctl status lightningd' for the status of the service. To stop, 'sudo systemctl stop lightningd'"
                        fi
                    fi
                fi
                # Output
                echo "bitcoind service installed - to enable run 'sudo systemctl start bitcoind' or 'sudo systemctl status bitcoind' for the status. To stop, 'sudo systemctl stop bitcoind'"
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

