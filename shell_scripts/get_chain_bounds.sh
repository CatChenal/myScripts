#!/bin/bash

#for dir in $( ls -l */head3.lst|awk '$NF ~ /^[A|D|Q|W]/{print $NF}')
#do
#  echo $dir
 #Following syntax deletes the shortest match of $substring from back of $string
#   echo ${dir%/head3.lst}

  awk -v pt="4" '$1 !~ /CL/ {ch=substr($2,1,2); if (ch=="A0") {sum4+=$4}}END{print "cA charge at pt"pt": ", sum4 }' sum_crg.out

  awk '$2 !~ /CL/ {ch=substr($2, 6,2); if (ch=="A0") {print $2}}' head3.lst | sed -n '1p;$p'

  awk -v pt="4" '$1 !~ /CL/ {ch=substr($2,1,2); if (ch=="B0") {sum4+=$4}}END{print "cB charge at pt"pt": ", sum4 }' sum_crg.out

  awk '$2 !~ /CL/ {ch=substr($2, 6,2); if (ch=="B0") {print $2}}' head3.lst | sed -n '1p;$p'

#done
