#!/bin/sh
#set -x
. ./env.sh

file=$0
shell_dir=$(dirname $0)
hosts_list=${shell_dir}/hosts.list
default_port=22
cmd=$@
type="command"
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

check_env;

while getopts ":ac:f:h:r::" opt; do
    case ${opt} in
		a|--append)
			append_host;
			;;
		f|--file)
			type="file"
			;;
		c|--command)
#			shift
			cmd=${OPTARG}
#			append_host
			;;	
		h|--host_file)
			host_file=${OPTARG}
			host_dir=$(cd "$(dirname "${host_file}")"; pwd);
			host_path=${host_dir}/${host_file}
			
			if [ -f "${host_path}" ];then
				hosts_list="${host_path}"
			fi		
			;;
		r|--remote_dir)
			echo ${OPTIND}
			remote_dir=${OPTARG}
			${OPTIND} ++ 
			local_dir=${OPTARG}
			echo ${local_dir}, ${OPTIND}
			exit
			;;
		:)
			echo $"Usage: {-f source destination |-c \"command\"}"
			exit 1
			;;		 
	esac
done

num=1
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
	echo "[${num}] ${host}:"
	if [ "$type" = "file" ];then
		res=$(expect ${shell_dir}/exec.exp $type ${host} ${port} ${username} ${password} "" ${src} ${dest}) 
	else
		res=$(expect ${shell_dir}/exec.exp $type ${host} ${port} ${username} ${password} "${cmd}")
	fi
	
	echo "${res}"|sed -n '3,$p'
	num=$((${num} + 1))
done < ${hosts_list}
