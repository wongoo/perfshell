
# performance test shell

## How to use

### ab performance test
1. make sure client can use `ssh` to connect server without password;
2. git clone on client: `git clone https://github.com/wongoo/perfshell.git`;
3. edit `host`,`process`,`url` in `ab_perf.sh` ;
4. edit ab request parameters in `ab_test.sh`;
5. run `nohup sh ab_perf.sh &` to start perf test, and `tailf nohup.out` to monitor progress;


### jmeter performance test

1. config jmeter thread group as follow, and save jmeter project to `test.jmx`
    - `Number of Threads (users)`: `${__P(threads,1)}`
    - `Ramp-Up Period (in seconds)`: `${__P(rampup,1)}`
    - `Loop Count`: `${__P(loops,1)}`

2. edit `host`,`process` in `jmeter_perf.sh` ;
3. run `nohup sh jmeter_perf.sh &` to start perf test, and `tailf nohup.out` to monitor progress;

### statistics process cpu/mem usage in period

eg, stat cpu/mem of `java` process on `192.168.5.111` with `60` seconds:
```
sh stat_proc_usage.sh java 192.168.5.111 60
```