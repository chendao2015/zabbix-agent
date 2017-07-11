zabbix-agent install guide
========

cd /usr/src

git clone https://github.com/chendao2015/zabbix-agent.git

cd zabbix-agent

tar xf zabbix-agent.tar.bz2

chmod +x zabbix-agent_install.sh

./zabbix-agent_install.sh


# explain
Please change following content to fit your environment in this script before you execute.
1) zabbix_server_ip  #This value must be set your zabbix server's ip address.
2) zabbix_server_port  #This value must be set your zabbix server's port.

The alterscripts directory is used to store third party scripts.

If you have some script for zabbix monitor,Please put it on alterscripts directory.

If you have executed script zabbix-agent_install.sh,Please put your script on /etc/zabbix/alterscripts directory.
