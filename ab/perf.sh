#!/bin/sh

# server host to monitor
host=192.168.0.2

# process name on host to provide service
# which is used to monitor memory usage of process
process=java

# test url of host service 
url=http://192.168.0.2/user

scp calccpu.sh $host:/tmp
scp calcmem.sh $host:/tmp
scp memstat.sh $host:/tmp

for n in 10 100 500 1000
do
	num=$(($n * 10000))
	for c in 10 50 100 200
	do
		echo $num, $c
		/tmp/abtest.sh $num $c $process $host $url
		sleep 30
	done
done

