#!/bin/sh

awk 'BEGIN {count=0;total=0;} {total=total+$3; count++;}; END{ if(count==0){count=1;} print total/count"%";}' $1

