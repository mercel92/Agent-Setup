#!/bin/bash 
ip=$1
server_ip="server_ip.txt"

if [[ -n "$ip" ]]; then
    echo "$1" >> ${server_ip}
else
    echo "argument error"
fi


pkill -f agent.py

cat > /usr/src/monitoring-agent-update.sh <<EOFMARKER7
#!/bin/bash
pkill -f agent.py
cd /usr/src/monitoring-agent/
git reset --hard
git pull https://github.com/mercel92/monitoring-agent.git
EOFMARKER7

cd /usr/src/
git clone https://github.com/mercel92/monitoring-agent.git monitoring-agent
chmod u+x /usr/src/monitoring-agent-update.sh
echo '@reboot python /usr/src/monitoring-agent/agent.py' >> /var/spool/cron/root
#echo '22 13 * * * sh /usr/src/monitoring-agent-update.sh' >> /var/spool/cron/root
echo 'nohup python /usr/src/monitoring-agent/agent.py' >> /home/avni/monitoring-agent-update.sh

nohup python /usr/src/monitoring-agent/agent.py
