#!/bin/bash
threads=$1
loops=$2
process=$3
host=$4
url=$5

ps_stat_file="/tmp/jmeter-$threads-$loops-$process.ps_stat"
vmstat_file="/tmp/jmeter-$threads-$loops-$process.vmstat"
jmeter_jtl="/tmp/jmeter-$threads-$loops-$process.jtl"
rm -f ${jmeter_jtl}

ssh -n ${host} "nohup sh /tmp/ps_stat.sh $process $ps_stat_file >/dev/null 2>&1 &"
ssh -n ${host} "nohup vmstat 2 >$vmstat_file  &"
sleep 2

echo "---------------------------------------"
echo "start jmeter request thread: $threads,loop: $loops, process: $process"
JVM_ARGS="-Xms1024m -Xmx1024m" jmeter -n -t test.jmx -l ${jmeter_jtl} -Jthreads=${threads} -Jloops=${loops}
echo "end jmeter request thread: $threads,loop: $loops, process: $process"

ssh ${host} "ps aux | grep -v grep | grep ps_stat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh ${host} "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh ${host} "sh /tmp/calc_ps_mem.sh $ps_stat_file" > /tmp/jmeter_mem.txt
ssh ${host} "sh /tmp/calc_vmstat_cpu.sh $vmstat_file" > /tmp/jmeter_cpu.txt

mem=$(cat /tmp/jmeter_mem.txt)
cpu=$(cat /tmp/jmeter_cpu.txt)

echo "$threads,$loops,$process, cpu: $cpu, mem: $mem"
echo "$threads,$loops,$process, cpu: $cpu, mem: $mem" >> /tmp/jmeter_perf-result.txt
