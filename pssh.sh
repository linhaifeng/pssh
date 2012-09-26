#!/bin/sh
#set -x
. ./env.sh

file=$0
shell_dir=$(cd "$(dirname "$0")";pwd)
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

. ./thread.sh
multi_thread_execute ${hosts_list}
