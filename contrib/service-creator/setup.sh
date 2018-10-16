#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
    echo "Please run this utility with sudo or root"
    exit 1
fi

if command -v pwgen 2>&1 1>/dev/null; [ "$?" -ne "0" ]; then
  echo "'pwgen' package needs to be installed. If you're on Debian-based system, you can install it with:"
  echo "	sudo apt install -y pwgen"
  exit 1
fi


if [ $(uname -m) == "armv7l" ]; then
  # This is ARM 64 specific
  if ! docker images | grep 0.17.0-arm7; then
      echo "Image doesnt exist - Downloading"
      docker pull lncm/bitcoind:0.17.0-arm7
  fi
elif [ $(uname -m) == "x86_64" ]; then
  if ! docker images | grep 0.17.0-x64; then
      echo "Image doesnt exist - Downloading"
      docker pull lncm/bitcoind:0.17.0-x64
  fi
else
  echo "Docker images aren't supported for this system (probably a PI Zero?)"
  # TODO: Install https://github.com/gdassori/spruned/
  # Install dependencies
  sudo apt-get install -y libleveldb-dev python3-dev git virtualenv gcc g++
  # Set up build directory
  mkdir -p /home/pi/source
  cd /home/pi/source
  git clone https://github.com/gdassori/spruned.git
  cd spruned
  virtualenv -p python3.6 venv
  . venv/bin/activate
  pip install -r requirements.txt
  python setup.py install
  chown -R pi.pi /home/pi/source

fi

if [ -f /usr/bin/docker ]; then
    if [ -d /home/pi/data ]; then
        # Check if BTC exists
        if [ -d /home/pi/data/btc ] || [ -d /home/pi/.bitcoin ]; then
           if [ -f /home/pi/data/btc/bitcoin.conf ] || [ -f /home/pi/.bitcoin/bitcoin.conf ]; then
                # If all the pieces of bitcoin is there
                if [ -d /home/pi/data/btc ]; then
                  # If its a docker based install
                  if [ ! -f /etc/systemd/system/bitcoind.service ]; then
                    # If the service file doesn't exist, create it
                    cat <<EOF >  /etc/systemd/system/bitcoind.service
[Unit]
Description=Bitcoin daemon
After=network.target
ConditionPathExists=/home/pi/data/btc
ConditionPathExists=/home/pi/data/btc/bitcoin.conf
ConditionPathExists=/home/pi/data/btc/chainstate
ConditionPathExists=/home/pi/data/btc/blocks

[Service]
ExecStart=/usr/bin/docker run --rm -v /home/pi/data:/data -p 8332:8332 -p 8333:8333 -p 28333:28333 -p 28332:28332 --name beyourownbank -d=true lncm/bitcoind:0.17.0-arm7
User=pi
Type=forking
RemainAfterExit=true
ExecStop=/usr/bin/docker exec -it beyourownbank /usr/local/bitcoin/bin/bitcoin-cli --datadir=/data/btc stop

[Install]
WantedBy=multi-user.target
EOF
                    # Installed now enable it
                    systemctl enable bitcoind
                  else
                    echo "/etc/systemd/system/bitcoind.service exists.. Skipping"
                  fi
                else
                  # Not a docker based install
                  echo "Not a docker based install lets skip this. Besides we are not using a bitcoind on this instance"
                fi
                # Check for lightningd (lets try to set it up)
                if [ -d /home/pi/data/lightningd ]; then
                    if [ -f /home/pi/data/lightningd/config ]; then
                        # Yay! We got a configured lighting
                        if [ $(uname -m) == "armv7l" ] || [ $(uname -m) == "x86_64" ]; then
                          # If we can use docker set up an entry point file
                          LNENTRYPOINT=/home/pi/data/ln.sh
                          # Set up LN Entrypoint
                          if [ ! -f $LNENTRYPOINT ]; then
                              cat <<EOF >$LNENTRYPOINT
#!/bin/bash
/usr/local/bin/lightningd --lightning-dir=/data/lightningd
EOF
                              chmod 755 $LNENTRYPOINT
                          fi
                        fi
                        # Entrypoint created

                        # set up service
                        # Pull the image depending on architecture
                        # PI zero not supported with building stuff on docker :/ So have to build it on box
                        if [ $(uname -m) == "armv7l" ]; then
                          # If ARM Arch
                          if ! docker images | grep 0.6.1-arm7; then
                              echo "LN Image doesnt exist - Downloading"
                              docker pull lncm/clightning:0.6.1-arm7
                          fi
                        elif [ $(uname -m) == "x86_64" ]; then
                          if ! docker images | grep 0.6.1-x64; then
                            docker pull lncm/clightning:0.6.1-x64
                          fi
                        else
                          echo "TODO: download and build c-lightning"
                        fi
                        # Create lightningd service IF its a docker based system
                        if [ $(uname -m) == "armv7l" ] || [ $(uname -m) == "x86_64" ]; then
                          if [ -f /etc/systemd/system/lightningd.service ]; then
                            cat <<EOF >  /etc/systemd/system/lightningd.service
[Unit]
Description=C lightning daemon
After=network.target
ConditionPathExists=/home/pi/data/lightningd
ConditionPathExists=/home/pi/data/lightningd/config

[Service]
ExecStart=/usr/bin/docker run -it --rm --entrypoint="/data/ln.sh" -v /home/pi/data:/data -v /home/pi/data/lightningd:/root/.lightning -p 9735:9735 -d=true --name lightningpay lncm/clightning:0.6.1-arm7
User=pi
Type=forking
RemainAfterExit=true
ExecStop=/usr/bin/docker stop lightningpay

[Install]
WantedBy=multi-user.target
EOF
                            # lightningd service created, enable it
                            systemctl enable lightningd
                          fi
                          # Print service creation
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
