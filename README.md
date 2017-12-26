zabbix-agent install guide
========
```Bash
cd /usr/src

git clone https://github.com/chendao2015/zabbix-agent.git

cd zabbix-agent

tar xf zabbix-agent.tar.bz2

chmod +x zabbix-agent_install.sh

./zabbix-agent_install.sh
```


# explain

The alterscripts directory is used to store third party scripts.

If you have some script for zabbix monitor,Please put it on alterscripts directory.

If you have executed script zabbix-agent_install.sh,Please put your script on /etc/zabbix/alterscripts directory.
