#!/bin/bash

concurrent=$1
loops=$2
process=$3
host=$4
url=$5

request_number=$(($concurrent * $loops))

memstat_file="/tmp/ab-$concurrent-$loops-$process.memstat"
vmstat_file="/tmp/ab-$concurrent-$loops-$process.vmstat"
ab_file="/tmp/ab-$concurrent-$loops-$process.ab"
rm -f ${ab_file}

ssh -n ${host} "nohup /tmp/memstat.sh $process $memstat_file >/dev/null 2>&1 &"
ssh -n ${host} "nohup vmstat 5 >$vmstat_file  &"
sleep 5

echo "---------------------------------------"
echo "start ab concurrent: $concurrent, loops: $loops, process: $process"

# ---> POST
# ab -n ${request_number} -c ${concurrent} -T "application/x-www-form-urlencoded" -p /tmp/ab-post.dat ${url} > ${ab_file}
# ---> GET
ab -n ${request_number} -c ${concurrent} ${url} > ${ab_file}

echo "end ab concurrent: $concurrent, loops: $loops, process: $process"

ssh ${host} "ps aux | grep -v grep | grep memstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh ${host} "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh ${host} "/tmp/calcmem.sh $memstat_file" > /tmp/ab-mem.txt
ssh ${host} "/tmp/calccpu.sh $vmstat_file" > /tmp/ab-cpu.txt

mem=$(cat /tmp/ab-mem.txt)
cpu=$(cat /tmp/ab-cpu.txt)
tps=$(grep "Requests per second" ${ab_file})
fails=$(grep "Failed requests" ${ab_file})

echo "concurrent: $concurrent, loops: $loops, process: $process, cpu: $cpu, mem: $mem , $tps, $fails"
echo "concurrent: $concurrent, loops: $loops, process: $process, cpu: $cpu, mem: $mem , $tps, $fails" >> /tmp/ab-perf-result.txt

