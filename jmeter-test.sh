#!/bin/bash
reqnum=$1
threads=$2
process=$3
host=$4
url=$5

loops=$((reqnum / threads))

memstatfile="/tmp/jmeter-$reqnum-$threads-$process.memstat"
vmstatfile="/tmp/jmeter-$reqnum-$threads-$process.vmstat"
jmeterjtl="/tmp/jmeter-$reqnum-$threads-$process.jtl"
rm -f $jmeterjtl

ssh -n $host "nohup /tmp/memstat.sh $process $memstatfile >/dev/null 2>&1 &"
ssh -n $host "nohup vmstat 5 >$vmstatfile  &"
sleep 5

#-----------------------<<<< jmeter TEST START
echo "start jmeter $reqnum,$threads,$loops,$process"
jmeter -n -t test.jmx -l $jmeterjtl -Jthreads=$threads -Jloops=$loops
echo "end jmeter $reqnum,$threads,$loops,$process"
#-----------------------<<<< jmeter TEST END

ssh $host "ps aux | grep -v grep | grep memstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh $host "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh $host "/tmp/calcmem.sh $memstatfile" > /tmp/jmeter-mem.txt
ssh $host "/tmp/calccpu.sh $vmstatfile" > /tmp/jmeter-cpu.txt

mem=$(cat /tmp/jmeter-mem.txt)
cpu=$(cat /tmp/jmeter-cpu.txt)

echo "$reqnum,$threads,$process, cpu: $cpu, mem: $mem"
echo "$reqnum,$threads,$process, cpu: $cpu, mem: $mem" >> /tmp/jmeter-perf-result.txt

