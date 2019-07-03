
# performance test shell

## How to use

### ab performance test
1. make sure client can use `ssh` to connect server without password;
2. git clone on client: `git clone https://github.com/wongoo/perfshell.git`;
3. edit `host`,`process`,`url` in `ab-perf.sh` ;
4. edit ab request parameters in `ab-test.sh`;
5. run `nohup sh ab-perf.sh &` to start perf test, and `tailf /tmp/nohup.out` to monitor progress;


### jmeter performance test

1. config jmeter thread group as follow, and save jmeter project to `test.jmx`
    - `Number of Threads (users)`: `${__P(threads,1)}`
    - `Ramp-Up Period (in seconds)`: `${__P(threads,1)}`
    - `Loop Count`: `${__P(loops,1)}`

2. edit `host`,`process` in `ab-perf.sh` ;
3. run `nohup sh jmeter-perf.sh &` to start perf test, and `tailf /tmp/nohup.out` to monitor progress;
