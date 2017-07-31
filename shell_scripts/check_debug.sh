#!/bin/bash

start_with="sliceAB-"
#start_with="clusterAB-"

echo "Bad connectivity list:" > tmp

for fldr in $(ls |grep $start_with |grep 025e4)
do
#   Error! get_connect12(): connectivity of atom " C   VAL A0069" is not complete:
#   1      2                3            4  5    6 7   8   9      10 11   12

  egrep 'not complete' $fldr/debug.log|egrep -v 'AB-30|0460|0018|0017|0458'| \
  nawk -v here="$fldr" ' {print here, $7,$8,$9}' >> tmp
  echo "." >> tmp
done

 sed '/clusterAB-30-025e4/d; s/\"$//' tmp > $start_with"connect.log"
 cat $start_with"connect.log"

/bin/rm -f tmp
