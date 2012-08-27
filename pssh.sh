#!/bin/sh
#set -x

file=$0
shell_dir=$(dirname $0)
hosts_list=${shell_dir}/hosts.list
default_port=22
cmd=$@
type=$1
src=$2
dest=$3

append_host(){
	printf "please input host:"
	read host
	printf "please input port:"
	read port
	printf "please input username:"
	read username
	printf "please input password:"
	read password
	if [ "${port}" = "" ];then
		txt="${host} ${username} ${password}"
	else
		txt="${host}:${port} ${username} ${password}"
	fi
	
	echo ${txt} >> ${hosts_list}

	read -p "continue?(y/n)" continue
	continue=$(echo ${continue}|tr A-Z a-z)
	if [ "${continue}" = "y" ];then
		append_host	
	else
		exit 0
	fi
}

init(){
	if [ ! -f "${hosts_list}" ];then
		touch ${hosts_list}
		append_host	
	fi
}

check_expect(){
	res=$(whereis expect)
	path=$(echo ${res}|awk -F":" '{print $2}')
	if [ "$path" = "" ];then
		yum -y install expect
	fi
}

check_scp(){
	res=$(whereis scp)
	path=$(echo ${res}|awk -F":" '{print $2}')
	if [ "$path" = "" ];then
		yum -y install scp
	fi
}

check_env(){
	check_expect;
	check_scp;
	init	
}

check_env;


case "$1" in
	-a)
		append_host
		;;
	-f)
		;;
	-c)		
		shift
		cmd=$@
		;;
	*)
		echo $"Usage: {-f source destination |-c command}"
		exit 1;
esac

while read -r host_info
do
	host_port=$(echo ${host_info}|awk '{print $1}')

	host=$(echo ${host_port}|awk -F ":" '{print $1}')
	port=$(echo ${host_port}|awk -F ":" '{print $2}')
	if [ "" = "${port}" ];then
		port=${default_port}
    fi
	
	username=$(echo ${host_info}|awk '{print $2}')
	password=$(echo ${host_info}|awk '{print $3}')

	echo "===========seperator line========"
	echo ${host}:
	if [ "$type" = "-f" ];then
		res=$(expect ${shell_dir}/exec.exp $type ${host} ${port} ${username} ${password} "" ${src} ${dest}) 
	else
		res=$(expect ${shell_dir}/exec.exp $type ${host} ${port} ${username} ${password} "${cmd}")
	fi
	
	echo "${res}"|sed -n '3,$p'
done < ${hosts_list}
