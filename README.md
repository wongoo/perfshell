
# performance test shell

## How to use

- make sure client can use `ssh` to connect server without password;
- copy all scripts to the dir `/tmp` of client;
- edit `host`,`process`,`url` in `ab-perf.sh` ;
- edit ab request parameters in `ab-test.sh`;
- run `nohup /tmp/ab-perf.sh &` to start perf test, and `tailf /tmp/nohup.out` to monitor progress;


