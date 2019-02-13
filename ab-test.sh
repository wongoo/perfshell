#!/bin/bash
reqnum=$1
concurrent=$2
process=$3
host=$4
url=$5

memstatfile="/tmp/ab-$reqnum-$concurrent-$process.memstat"
vmstatfile="/tmp/ab-$reqnum-$concurrent-$process.vmstat"
abfile="/tmp/ab-$reqnum-$concurrent-$process.ab"
rm -f $abfile

ssh -n $host "nohup /tmp/memstat.sh $process $memstatfile >/dev/null 2>&1 &"
ssh -n $host "nohup vmstat 5 >$vmstatfile  &"
sleep 5

#-----------------------<<<< AB TEST START
echo "start ab $reqnum,$concurrent,$process"
ab -n $reqnum -c $concurrent -T "application/x-www-form-urlencoded" -p /tmp/ab-post.dat $url > $abfile
echo "end ab $reqnum,$concurrent,$process"
#-----------------------<<<< AB TEST END

ssh $host "ps aux | grep -v grep | grep memstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"
ssh $host "ps aux | grep -v grep | grep vmstat  | cut -c 9-15 | xargs --no-run-if-empty kill -9"

ssh $host "/tmp/calcmem.sh $memstatfile" > /tmp/ab-mem.txt
ssh $host "/tmp/calccpu.sh $vmstatfile" > /tmp/ab-cpu.txt

mem=$(cat /tmp/ab-mem.txt)
cpu=$(cat /tmp/ab-cpu.txt)
tps=$(grep "Requests per second" $abfile)
fails=$(grep "Failed requests" $abfile)

echo "$reqnum,$concurrent,$process, cpu: $cpu, mem: $mem , $tps, $fails"
echo "$reqnum,$concurrent,$process, cpu: $cpu, mem: $mem , $tps, $fails" >> /tmp/ab-perf-result.txt

