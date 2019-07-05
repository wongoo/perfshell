#!/bin/sh

awk 'BEGIN {count=0;total=0;} {if($13>2 && $13!="us"){total=total+($13+$14); count++;}}; END{if(count==0){count=1;} print total/count"%";}' $1

