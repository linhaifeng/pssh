#!/bin/sh

function execute {
	host_info="$1";
	num=$2;
	host_port=$(echo ${host_info}|awk '{print $1}')

	host=$(echo ${host_port}|awk -F ":" '{print $1}')
	port=$(echo ${host_port}|awk -F ":" '{print $2}')
	if [ "" = "${port}" ];then
		port=${default_port}
    fi
	
	username=$(echo ${host_info}|awk '{print $2}')
	password=$(echo ${host_info}|awk '{print $3}')

	if [ "$type" = "file" ];then
		res=$(expect ${shell_dir}/exec.exp $type ${host} ${port} ${username} ${password} "" ${src} ${dest}) 
	else
		res=$(expect ${shell_dir}/exec.exp $type ${host} ${port} ${username} ${password} "${cmd}")
	fi
	
	echo "[${num}] ${host}:"
	
	echo "${res}"|sed -n '3,$p'
	
	echo "===========seperator line========"
	
}

function multi_thread_execute {
	hosts_file=$1
	lines=$(cat ${hosts_file}|grep -v '^$'|wc -l)

	tmp_fifofile="/tmp/$.fifo"
	mkfifo $tmp_fifofile
	exec 6<> $tmp_fifofile
	rm $tmp_fifofile
	thread=15
	for ((i=0;i<$thread;i++));do
		echo
	done >&6

	for ((i=0;i<${lines};i++));do
		line=$(($i+1))
		host_info=$(sed -n "${line}p" ${hosts_file})
		read -u6
		{
			execute "${host_info}" ${i}
			echo >&6
		} &
	done
	wait
	exec 6>&-
	exit 0
}
