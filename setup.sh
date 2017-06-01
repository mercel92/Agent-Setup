#!/bin/bash


value=$(cat /etc/os-release | grep -m 1 "ID")
if [ $value == 'ID="centos"' ]; then
yum -y update
yum -y install gcc python python-pip python-devel
pip install --upgrade pip
echo '@reboot python /usr/src/tagent/agent.py' >> /var/spool/cron/root
echo '@reboot python /usr/src/tagent/update.py' >> /var/spool/cron/root
else
apt-get -y update
apt-get -y install python python-pip
echo '@reboot python /usr/src/tagent/agent.py' >> /var/spool/cron/crontabs/root
echo '@reboot python /usr/src/tagent/update.py' >> /var/spool/cron/crontabs/root
fi

rm -rf /usr/src/tagent/
pkill -f agent.py
pkill -f update.py

ip=$1
server_ip="server_ip.txt"

if [ -n "$ip" ]; then
echo "$1" >> ${server_ip}
else
    echo "argument error"
fi

cd /usr/src/
git clone https://github.com/mercel92/monitoring-agent.git tagent


cat > /usr/src/tagent/tagent-update.sh <<EOFMARKER7
#!/bin/bash
cd /usr/src/tagent/
git reset --hard
git pull
pkill -f agent.py
pkill -f update.py
EOFMARKER7

chmod u+x /usr/src/tagent/tagent-update.sh
echo 'nohup python /usr/src/tagent/update.py >/dev/null 2>&1 &' >> /usr/src/tagent/tagent-update.sh
echo 'nohup python /usr/src/tagent/agent.py >/dev/null 2>&1 &' >> /usr/src/tagent/tagent-update.sh

mv /usr/src/server_ip.txt /usr/src/tagent/
nohup python /usr/src/tagent/update.py >/dev/null 2>&1 & 
nohup python /usr/src/tagent/agent.py >/dev/null 2>&1 &
