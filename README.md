# zabbix-agent install guide
cd /usr/src

git clone https://github.com/chendao2015/zabbix-agent.git

cd zabbix-agent

tar xf zabbix-agent.tar.bz2

chmod +x zabbix-agent_install.sh


# Please change following content to fit your environment in this script before you execute.
1) zabbix_server_ip  #The value must be set your zabbix server's ip address.
2) zabbix_server_port  #The value must be set your zabbix server's port.


./zabbix-agent_install.sh
