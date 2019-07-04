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
for threads in 10 50 100 200
do
	for loops in 20 50
	do
        echo "------> request threads: ${threads}, loops: $loops"
		sh jmeter-test.sh ${threads} ${loops} ${process} ${host}
		sleep 30
	done
done

