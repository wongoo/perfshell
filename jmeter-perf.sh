#!/bin/sh

# server host to monitor
host=10.104.110.72

# process name on host to provide service
# which is used to monitor memory usage of process
process=java

scp calccpu.sh ${host}:/tmp
scp calcmem.sh ${host}:/tmp
scp memstat.sh ${host}:/tmp

# ----------------------------
# jmeter test
# ----------------------------
for n in 1 5 10
do
	num=$(($n * 10000))
	for concurrent in 10 50 100 200
	do
		echo "------> ${num}, ${concurrent}"
		sh jmeter-test.sh ${num} ${concurrent} ${process} ${host}
		sleep 30
	done
done

