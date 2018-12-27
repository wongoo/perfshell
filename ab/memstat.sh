#!/bin/sh

rm -f $2

for (( ; ; ))
do
   sleep 5
   # ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' |grep $1 | grep -v grep  >> $2
   ps -e -o 'comm,rsz' |grep $1 | grep -v grep  >> $2
done

