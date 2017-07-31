#!/bin/bash

# remove gaps in conf id if any;
# ARG+A0017_  1.00  1.00  1.00  1.00  1.00
# LYS A0216
filename="sum_crg.out"

# In case col1=conf_id and malformatted (space btw RES and num:
blank=$(sed -n '2p' $filename|cut -c1-9|sed 's/ /@/'|awk '{if(substr($1,4,1)=="@"){print 1} else {print 0}}')

sed 's/\(^...\) \(......\)/\1_\2/' $filename > $filename.new

head  $filename.new

