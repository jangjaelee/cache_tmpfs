#!/bin/bash
# -*-Shell-script-*-
#
#/**
# * Title    : tmpfs for DB cache remove
# * Auther   : Alex, Lee
# * Created  : 2019-05-28
# * Modified : 
# * E-mail   : cine0831@gmail.com
#**/
#
#set -e
#set -x

switch_conf="/usr/local/cache_tmpfs/cache_tmpfs.conf"

if [ -f ${switch_conf} ]
then
    . ${switch_conf}
else
    switch="off"
    cache_tmpfs="NULL"
    tmpfs_size="0"
fi

function usage {
    echo "
 Usage: $_  -m         : for mounting
                                                -u         : for umounting

"
}

function msg {
    local msg="$1"
    echo "${cache_tmpfs} ${msg}"
}

function mount_status {
    local i="$1"
    local mnt_status=$(mount -v | grep '\/cache_tmpfs' | awk '{print $3}' | sort -u)
    if [[ "${cache_tmpfs}" == "${mnt_status}" ]]
    then
        i="${i}1"
    fi   
 
    if [[ "${i}" == "11" ]]
    then
        msg "tmpfs is already mounted."
        exit 1
    fi

}

function mounting {
    if [[ -d ${cache_tmpfs} ]] && [[ "${switch}" == "on" ]]
    then 
        mount -o size=${tmpfs_size} -t tmpfs tmpfs ${cache_tmpfs}
        retval=$?
        if [ $retval -eq 0 ]
        then
            chmod 755 ${cache_tmpfs}
            chown nobody.nobody ${cache_tmpfs}
            msg "tmpfs mounting is successed."
        else
            msg "tmpfs mounting is failed."
        fi
    fi
}

function umounting {
    umount ${cache_tmpfs}
    retval=$?
    if [ $retval -eq 0 ]
    then
        msg "tmpfs unmounting is successed."
    else
        msg "tmpfs unmounting is failed."
    fi
}

case "$1" in
    "-m")
       mount_status "1"
       mounting 
       ;;
    "-u")
       mount_status "0"
       umounting
       ;;
    "-h"|*)
       usage
       exit 0
       ;;
esac
