#!/bin/bash 
ip=$1
server_ip="server_ip.txt"

if [[ -n "$ip" ]]; then
    echo "$1" >> ${server_ip}
else
    echo "argument error"
fi


pkill -f agent.py

cat > /usr/src/tagent/tagent-update.sh <<EOFMARKER7
#!/bin/bash
pkill -f agent.py
cd /usr/src/tagent/
git reset --hard
git pull https://github.com/mercel92/monitoring-agent.git
EOFMARKER7

cd /usr/src/
git clone https://github.com/mercel92/monitoring-agent.git tagent
chmod u+x /usr/src/tagent/monitoring-agent-update.sh
echo '@reboot python /usr/src/tagent/agent.py' >> /var/spool/cron/root
#echo '22 13 * * * sh /usr/src/tagent-update.sh' >> /var/spool/cron/root
echo 'nohup python /usr/src/tagent/agent.py' >> /usr/src/tagent-update.sh

nohup python /usr/src/tagent/agent.py
