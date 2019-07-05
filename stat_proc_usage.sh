#!/usr/bin/env bash

process=$1
host=$2
period=$3

TARGET_USER=root

scp ps_stat.sh ${TARGET_USER}@${host}:/tmp
scp calc_ps_mem.sh ${TARGET_USER}@${host}:/tmp
scp top_stat.sh ${TARGET_USER}@${host}:/tmp
scp calc_top_cpu.sh ${TARGET_USER}@${host}:/tmp

ps_stat_file=/tmp/stat-process-${process}.ps
top_stat_file=/tmp/stat-process-${process}.top

ssh -n ${TARGET_USER}@${host} "nohup sh /tmp/ps_stat.sh $process $ps_stat_file >/dev/null 2>&1 &"
ssh -n ${TARGET_USER}@${host} "nohup sh /tmp/top_stat.sh $process $top_stat_file >/dev/null 2>&1 &"

sleep ${period}

ssh ${TARGET_USER}@${host} "ps aux | grep -v grep | grep ps_stat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh ${TARGET_USER}@${host} "ps aux | grep -v grep | grep top_stat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh ${TARGET_USER}@${host} "sh /tmp/calc_ps_mem.sh $ps_stat_file" > /tmp/${process}_mem.txt
ssh ${TARGET_USER}@${host} "sh /tmp/calc_top_cpu.sh $top_stat_file" > /tmp/${process}_cpu.txt

mem=$(cat /tmp/${process}_mem.txt)
cpu=$(cat /tmp/${process}_cpu.txt)

echo "$process, cpu: $cpu, mem: $mem"
echo "$process, cpu: $cpu, mem: $mem" >> /tmp/stat-proc-usage.txt