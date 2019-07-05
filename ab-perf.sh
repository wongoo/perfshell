#!/bin/sh

# server host to monitor
host=192.168.0.2

# process name on host to provide service
# which is used to monitor memory usage of process
process=java

scp calccpu.sh ${host}:/tmp
scp calcmem.sh ${host}:/tmp
scp memstat.sh ${host}:/tmp

# ----------------------------
# ab test
# ----------------------------

# test url of host service 
url=http://192.168.0.2/user

for concurrent in 10 50 100 200
do
	for loops in 100 200
    do
		echo "------> concurrent: ${concurrent}, loops: ${loops}"
		sh ab-test.sh ${concurrent} ${loops} ${process} ${host} ${url}
		sleep 30
	done
done


