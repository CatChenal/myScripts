#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo " -----> Missing: folder id (for output file)"
  echo $0 " to be called in the folder to process"
  exit 0
fi

Run=$1
nawk 'BEGIN{ print "Conf", "epol" } $2 ~ /_CL-1/ {print $2,$(NF-3)}  ' head3.lst > $Run"-CL-epol.csv"
