#!/bin/bash
threads=$1
loops=$2
process=$3
host=$4
url=$5

memstat_file="/tmp/jmeter-$threads-$loops-$process.memstat"
vmstat_file="/tmp/jmeter-$threads-$loops-$process.vmstat"
jmeter_jtl="/tmp/jmeter-$threads-$loops-$process.jtl"
rm -f ${jmeter_jtl}

ssh -n ${host} "nohup sh /tmp/memstat.sh $process $memstat_file >/dev/null 2>&1 &"
ssh -n ${host} "nohup vmstat 5 >$vmstat_file  &"
sleep 5

echo "---------------------------------------"
echo "start jmeter request thread: $threads,loop: $loops, process: $process"
JVM_ARGS="-Xms1024m -Xmx1024m" jmeter -n -t test.jmx -l ${jmeter_jtl} -Jthreads=${threads} -Jloops=${loops}
echo "end jmeter request thread: $threads,loop: $loops, process: $process"

ssh ${host} "ps aux | grep -v grep | grep memstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh ${host} "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh ${host} "sh /tmp/calcmem.sh $memstat_file" > /tmp/jmeter-mem.txt
ssh ${host} "sh /tmp/calccpu.sh $vmstat_file" > /tmp/jmeter-cpu.txt

mem=$(cat /tmp/jmeter-mem.txt)
cpu=$(cat /tmp/jmeter-cpu.txt)

echo "$threads,$loops,$process, cpu: $cpu, mem: $mem"
echo "$threads,$loops,$process, cpu: $cpu, mem: $mem" >> /tmp/jmeter-perf-result.txt
