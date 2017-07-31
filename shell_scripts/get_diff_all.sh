#!/bin/bash
# input: pH directories


for dir in $(echo $1)
do
  for in_file in $(ls $dir/_CL-1A*.mfe$pH.csv)
do
  out=${mfe_file1:1:9}
  conf1=${mfe_file1:6:8}
  mfe_file2='_CL-1B'$conf1.mfe$pH.csv


