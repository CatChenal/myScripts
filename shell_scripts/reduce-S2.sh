#!/bin/bash

for conf in $(awk '{if($11>100) {print substr($2,6,14)}}' head3.lst)
do
  strSED=" '/$conf/d' "
  eval  sed -i "$strSED" step2_out.pdb
done
