#!/bin/bash
# To get ROIs distance from WT E148-OE atoms at pH4.5
#	ATOM   1017  OE1 GLU A 148      34.484  -4.469  15.103
#	ATOM   1018  OE2 GLU A 148      34.444  -2.348  14.487

for fldr in `ls -l | grep '^d'|awk '{print $NF}'`
do
  cd $fldr
  infile="$fldr"-rois4.5.pdb
  # cl000-rois4.5.pdb

  get-step2-dist-from-anchor.sh 34.484  -4.469  15.103 E148OE1 $infile;
  get-step2-dist-from-anchor.sh 34.444  -2.348  14.487 E148OE2 $infile;

  cd ../
done

