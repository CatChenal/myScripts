#!/bin/bash
infile=$1

awk 'BEGIN{i=1; prev=0} { if(NR==1){prev=$1} else { prev++}; if($1 != prev) {print $1"*"}}' $infile

