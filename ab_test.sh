#!/bin/bash

concurrent=$1
loops=$2
process=$3
host=$4
url=$5

request_number=$(($concurrent * $loops))

ps_stat_file="/tmp/ab-$concurrent-$loops-$process.ps_stat"
vmstat_file="/tmp/ab-$concurrent-$loops-$process.vmstat"
ab_file="/tmp/ab-$concurrent-$loops-$process.ab"
rm -f ${ab_file}

ssh -n ${host} "nohup sh /tmp/ps_stat.sh $process $ps_stat_file >/dev/null 2>&1 &"
ssh -n ${host} "nohup vmstat 2 >$vmstat_file  &"
sleep 2

echo "---------------------------------------"
echo "start ab concurrent: $concurrent, loops: $loops, process: $process"

# ---> POST
# ab -n ${request_number} -c ${concurrent} -T "application/x-www-form-urlencoded" -p /tmp/ab_post.dat ${url} > ${ab_file}
# ---> GET
ab -n ${request_number} -c ${concurrent} ${url} > ${ab_file}

echo "end ab concurrent: $concurrent, loops: $loops, process: $process"

ssh ${host} "ps aux | grep -v grep | grep ps_stat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh ${host} "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh ${host} "sh /tmp/calc_ps_mem.sh $ps_stat_file" > /tmp/ab_mem.txt
ssh ${host} "sh /tmp/calc_vmstat_cpu.sh $vmstat_file" > /tmp/ab_cpu.txt

mem=$(cat /tmp/ab_mem.txt)
cpu=$(cat /tmp/ab_cpu.txt)
tps=$(grep "Requests per second" ${ab_file})
fails=$(grep "Failed requests" ${ab_file})

echo "concurrent: $concurrent, loops: $loops, process: $process, cpu: $cpu, mem: $mem , $tps, $fails"
echo "concurrent: $concurrent, loops: $loops, process: $process, cpu: $cpu, mem: $mem , $tps, $fails" >> /tmp/ab_perf-result.txt

