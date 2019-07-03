#!/bin/bash
reqnum=$1
concurrent=$2
process=$3
host=$4
url=$5

memstat_file="/tmp/ab-$reqnum-$concurrent-$process.memstat"
vmstat_file="/tmp/ab-$reqnum-$concurrent-$process.vmstat"
ab_file="/tmp/ab-$reqnum-$concurrent-$process.ab"
rm -f ${ab_file}

ssh -n ${host} "nohup /tmp/memstat.sh $process $memstat_file >/dev/null 2>&1 &"
ssh -n ${host} "nohup vmstat 5 >$vmstat_file  &"
sleep 5

#-----------------------<<<< AB TEST START
echo "---------------------------------------"
echo "start ab request number: $reqnum, concurrent: $concurrent, process: $process"
ab -n ${reqnum} -c ${concurrent} -T "application/x-www-form-urlencoded" -p /tmp/ab-post.dat ${url} > ${ab_file}
echo "end ab request number: $reqnum, concurrent: $concurrent, process: $process"
#-----------------------<<<< AB TEST END

ssh ${host} "ps aux | grep -v grep | grep memstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh ${host} "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh ${host} "/tmp/calcmem.sh $memstat_file" > /tmp/ab-mem.txt
ssh ${host} "/tmp/calccpu.sh $vmstat_file" > /tmp/ab-cpu.txt

mem=$(cat /tmp/ab-mem.txt)
cpu=$(cat /tmp/ab-cpu.txt)
tps=$(grep "Requests per second" $ab_file)
fails=$(grep "Failed requests" $ab_file)

echo "$reqnum,$concurrent,$process, cpu: $cpu, mem: $mem , $tps, $fails"
echo "$reqnum,$concurrent,$process, cpu: $cpu, mem: $mem , $tps, $fails" >> /tmp/ab-perf-result.txt

