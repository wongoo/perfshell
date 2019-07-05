#!/bin/sh

# server host to monitor
host=10.104.110.72

# process name on host to provide service
# which is used to monitor memory usage of process
process=java

scp calc_vmstat_cpu.sh ${host}:/tmp
scp calc_ps_mem.sh ${host}:/tmp
scp ps_stat.sh ${host}:/tmp

# ----------------------------
# jmeter test
# ----------------------------
for threads in 10 50 100 200
do
	for loops in 20 50
	do
        echo "------> request threads: ${threads}, loops: $loops"
		sh jmeter_test.sh ${threads} ${loops} ${process} ${host}
		sleep 30
	done
done

