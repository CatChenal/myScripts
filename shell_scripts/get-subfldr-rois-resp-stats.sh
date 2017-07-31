#!/bin/bash
#  Cat Chenal @ Gunner Lab - 2001-10-21
# To obtain basic stats from 1+ subfolder(s) respair.lst for the given filelist of residue sequence identifyers [nnnn].
# The output is a tab-separated file for each res-id in the list with name [id]-resp-stats.csv
#
this="`basename $0`"
if [ $# -lt 1 ]; then
    echo "*** Missing argument: filelist of residue sequence identifyers [nnnn]. Exiting."
    exit 0
fi

for subfldr in `ls -l | grep '^d' | awk '{print $NF}'`
do
  echo "Processing $subfldr..."
  cd $subfldr
# Assuming list resides in top folder where fctn is called:
  for idn in `cat ../$1`
  do
    get-subfldrs-respair-stats.sh "$idn" > $idn-resp-stats.csv
    echo "	$idn:  done"
  done
  cd ../
done
echo "*** $this over."
