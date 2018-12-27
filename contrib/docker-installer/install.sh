SYSTEM=`uname -v`
if [ $(echo $SYSTEM | grep -ic alpine) == 0 ]; then
    echo "Non-Alpine System (Probably Raspbian)"
    sudo apt update && \
    sudo apt install -y apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \

    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add - && \
    echo "deb [arch=armhf] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list && \

    sudo apt update -y && \
    sudo apt install -y docker-ce 

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo usermod -aG docker $USER

    # Install required packages
    sudo apt update -y
    sudo apt install -y python python-pip
    sudo pip install docker-compose
else
    echo "Alpine system detected"
fi
