
# ab performance test shell

## How to use

- make sure client can use `ssh` to connect server without password;
- copy all schells to the dir `/tmp` of client;
- edit `perf.sh` to edit `host`,`process`,`url`;
- edit `abtest.sh` to edit ab request parameters;
- run `nohup /tmp/perf.sh &` to perf test, and `tailf /tmp/nohup.out` to monitor progress;


