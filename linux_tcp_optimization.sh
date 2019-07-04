#!/usr/bin/env bash

# one million, temp setting
ulimit -HSn 1000000

# reduce  time_wait
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout
echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse

# reduce close_wait
echo 60 > /proc/sys/net/ipv4/tcp_keepalive_time

# ip port range
echo 15000 64000 > /proc/sys/net/ipv4/ip_local_port_range

