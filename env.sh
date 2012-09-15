#!/bin/sh

is_redhat=true
is_debian=false
redhat_version=/etc/redhat-version
debian_version=/etc/debian_version
if [ -f {$redhat_version} ];then
   is_redhat=true
   is_debian=false
elif [ -f {$debian_version} ];then
   is_redhat=false
   is_debian=true
else
   is_redhat=is_debian=false
fi

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
            if [ {$is_redhat} ];then
                        yum -y install expect
            else
                        sudo apt-get install expect
            fi
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

