#!/bin/sh

rm -f $2

target_pid=$(ps aux |grep $1 |grep -v grep |grep -v memstat.sh| awk '{print $2}')

for (( ; ; ))
do
   sleep 2

   # ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' |grep $1 | grep -v grep  >> $2
   # ps -e  -o 'comm,rsz' |grep $1 | grep -v grep  >> $2

   ps  -p ${target_pid} -o 'comm,rsz' |grep -v COMMAND  >> $2

done
