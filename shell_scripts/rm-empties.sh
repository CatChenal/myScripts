#!/bin/bash

for empty in `ls -ls |awk '$6==0 {print $NF}'`
do
  rm $empty
done
