#!/bin/bash
sum=0
cnt=0
tmp="av.tmp"

if [ $# == 0 ];then
  echo "$0 returns the average of a list of numbers; none given."
  exit 0
fi
if [ -f "$tmp" ]; then
  /bin/rm $tmp
fi

# Check input as a command line list or file?
if [ $# -gt 1 ]; then
  touch $tmp
  for val in $@
  do
    echo $val>>$tmp
  done
  set $tmp
else
  if [ ! -f "$1" ]; then
    echo "Input file expected. Exiting."
    exit 0
  fi
fi

awk 'BEGIN{n=0;i=0;val=0; prtline=""} \
     { \
     for (n=1; n<=NF; n++) \
       c_$n[$n]=$n; next \
     }
     END{ \
     for (i=1; i<=NF; i++) \
       for val in c_$i
         if (!isnum($val) then \
           print "line ", NR, ", col ",$i," contains non-numerics, skipping it ..." \
           break \
         else \
           sum_$i+=val ; \
       prtline+=sum_$1/NR" " ;\
     {print prtline} \
     } \
     function isnum(x) \
      { return x == x + 0 } \
' $1
