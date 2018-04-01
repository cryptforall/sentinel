{\rtf1\ansi\ansicpg1252\cocoartf1404\cocoasubrtf470
{\fonttbl\f0\fmodern\fcharset0 Courier;\f1\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww18640\viewh12480\viewkind0
\deftab720
\pard\pardeftab720\sl280\partightenfactor0

\f0\fs24 \cf2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 #!/bin/bash\
sudo touch /var/swap.img\
sudo chmod 600 /var/swap.img\
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000\
mkswap /var/swap.img\
sudo swapon /var/swap.img\
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab\
sudo apt-get update -y\
sudo apt-get upgrade -y\
sudo apt-get dist-upgrade -y\
sudo apt-get install nano htop git -y\
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common -y\
sudo apt-get install libboost-all-dev -y\
sudo add-apt-repository ppa:bitcoin/bitcoin -y\
sudo apt-get update -y\
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y\
wget https://github.com/Xchange-platform/Xchange/releases/download/v1.1/Xchanged.tar.gz chmod -R 755 \
tar https://github.com/Xchange-platform/Xchange/releases/download/v1.1/Xchanged.tar.gz\
mkdir /root/Xchange\
mkdir /root/.Xchangecore\
cp /root/temp/src/Xchanged /root/Xchange\
cp /root/temp/src/Xchange-cli /root/Xchange\
chmod -R 755 /root/Xchange\
chmod -R 755 /root/.Xchangecore\
sudo apt-get install -y pwgen\
GEN_PASS=`pwgen -1 20 -n`\
echo -e "rpcuser=Xchangerpc\\nrpcpassword=$\{GEN_PASS\}\\n
\f1 server=1\\
\f0 nlisten=1\\nmaxconnections=256" > /root/.Xchangecore/Xchange.conf\
cd /root/Xchange\
./Xchange -daemon\
sleep 10\
masternodekey=$(./Xchange-cli masternode genkey)\
./Xchange-cli stop\
echo -e "masternode=1\\nmasternodeprivkey=$masternodekey" >> /root/.Xchangecore/Xchange.conf\
./Xchanged -daemon\
cd /root/.Xchangecore\
sudo apt-get install -y git python-virtualenv\
sudo git clone https://github.com/Xchange-platform/sentinel.git\
cd sentinel\
export LC_ALL=C\
sudo apt-get install -y virtualenv\
virtualenv venv\
venv/bin/pip install -r requirements.txt\
echo \'93Xchange_conf=/root/.Xchangecore/Xchange.conf" >> /root/. \cf0 \outl0\strokewidth0 Xchangecore\cf2 \outl0\strokewidth0 \strokec2 /sentinel/sentinel.conf\
crontab -l > tempcron\
echo "* * * * * cd /root/. \cf0 \outl0\strokewidth0 Xchangecore\cf2 \outl0\strokewidth0 \strokec2 /sentinel && ./venv/bin/python bin/sentinel.py 2>&1 >> sentinel-cron.log" >> tempcron\
crontab tempcron\
rm tempcron\
echo "Masternode private key: $masternodekey"\
echo "Job completed successfully"\
}