#!/bin/sh

rm -f $2

target_pid=$(ps aux |grep $1 |grep -v grep |grep -v top_stat.sh| awk '{print $2}')

for (( ; ; ))
do
   sleep 2

   top -b -n 1 -d 0.2 -p ${target_pid} | tail -1 | awk '{print $9}'  >> $2

done
