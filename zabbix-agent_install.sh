#!/bin/bash
#Version:1.0
#Author:sean.cheng
#Date:20170710

if [ $UID -ne 0 ];then
	echo 'Please run this scripts by root user'
	exit 1
fi

basedir=/usr/src/zabbix-agent/packages
config_file=/etc/zabbix/zabbix_agentd.conf
host_name=$(hostname)
zabbix_server_ip=172.16.1.1
port=10051

if [ -f /etc/redhat-release ];then
	kernel_version=$(awk -F'[ .]+' '{print $3}' /etc/redhat-release)
elif [ -f /etc/os-release ];then
	kernel_version=$(awk -F'"' '/VERSION_ID/{print $2}' /etc/os-release)
	OS_NAME=ubuntu
else
	echo "Unknow OS"
fi


#zabbix install
cd $basedir
if [ $kernel_version -eq 5 ];then
	#wget http://repo.zabbix.com/zabbix/3.0/rhel/5/x86_64/zabbix-agent-3.0.4-1.el5.x86_64.rpm
	rpm -ivh zabbix-agent-3.0.4-1.el5.x86_64.rpm
elif [ $kernel_version -eq 6 ];then
	#wget http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-agent-3.0.4-1.el6.x86_64.rpm
	rpm -ivh zabbix-agent-3.0.4-1.el6.x86_64.rpm
elif [ $kernel_version -eq 7 ];then
	#wget http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-agent-3.0.4-1.el7.x86_64.rpm
	rpm -ivh zabbix-agent-3.0.4-1.el7.x86_64.rpm
else
	if [ $kernel_version == '12.04' ];then
		#wget http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix/zabbix-agent_2.2.4-1+trusty_amd64.deb
		dpkg -i zabbix-agent_2.2.4-1+trusty_amd64.deb
	else
		#wget http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix/zabbix-agent_3.0.4-1+trusty_amd64.deb
		dpkg -i zabbix-agent_3.0.4-1+trusty_amd64.deb
	fi
fi


# config zabbix-agent
\cp -a /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf-original
\cp -a /usr/src/zabbix-agent/alterscripts /etc/zabbix/
echo "$zabbix_server_ip zabbix.sumscope.com zabbix" >> /etc/hosts

sed -i "s#Hostname=.*#Hostname=$host_name#g" $config_file
sed -i "s#Server=.*#Server=zabbix#g" $config_file
sed -i "s#ServerActive=.*#ServerActive=zabbix:${port}#g" $config_file

cat >> $config_file <<'EOF'
UnsafeUserParameters=1
UserParameter=tcp[*],netstat -an |grep -c $1
UserParameter=check_proc[*],sh /etc/zabbix/alterscripts/check_proc.sh
UserParameter=check_logs[*],sh /etc/zabbix/alterscripts/check_log.sh $1 $2
UserParameter=check_v_logs[*],sh /etc/zabbix/alterscripts/check_log_v.sh $1 $2
UserParameter=check_port[*],sh /etc/zabbix/alterscripts/check_port_sh.sh
UserParameter=top_record[*],sh /etc/zabbix/alterscripts/top_record.sh
UserParameter=top_process_cpu[*],sh /etc/zabbix/alterscripts/top_process_cpu.sh
UserParameter=top_process_mem[*],sh /etc/zabbix/alterscripts/top_process_mem.sh
UserParameter=top_process_mem_5G[*],sh /etc/zabbix/alterscripts/top_process_mem_5G.sh
UserParameter=top_process_mem_10G[*],sh /etc/zabbix/alterscripts/top_process_mem_10G.sh
EOF

# start zabbix-agent service
if [ $kernel_version -eq 7 ];then
	systemctl enable zabbix-agent.service
	systemctl start zabbix-agent.service
else
	cp -a /etc/rc.local /etc/rc.local-original
	echo 'service zabbix-agent start' >> /etc/rc.local
	service zabbix-agent start
fi

echo '==========================Done==========================='
