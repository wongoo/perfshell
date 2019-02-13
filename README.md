
# performance test shell

## How to use

- make sure client can use `ssh` to connect server without password;
- copy all scripts to the dir `/tmp` of client;
- edit `ab-perf.sh` to edit `host`,`process`,`url`;
- edit `ab-test.sh` to edit ab request parameters;
- run `nohup /tmp/ab-perf.sh &` to start perf test, and `tailf /tmp/nohup.out` to monitor progress;


