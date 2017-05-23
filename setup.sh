#!/bin/bash
rm -rf /usr/src/tagent/
pkill -f agent.py

ip=$1
server_ip="server_ip.txt"

if [[ -n "$ip" ]]; then
    echo "$1" >> ${server_ip}
else
    echo "argument error"
fi

cd /usr/src/
git clone https://github.com/mercel92/monitoring-agent.git tagent
echo '@reboot python /usr/src/tagent/agent.py' >> /var/spool/cron/root
#echo '22 13 * * * sh /usr/src/tagent-update.sh' >> /var/spool/cron/root

cat > /usr/src/tagent/tagent-update.sh <<EOFMARKER7
#!/bin/bash
pkill -f agent.py
cd /usr/src/tagent/
git reset --hard
git pull
EOFMARKER7

chmod u+x /usr/src/tagent/tagent-update.sh
echo 'nohup python /usr/src/tagent/agent.py' >> /usr/src/tagent/tagent-update.sh
mv /usr/src/setup/server_ip.txt /usr/src/tagent/
nohup python /usr/src/tagent/agent.py
