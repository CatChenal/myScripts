#!/bin/bash
# Scriptname: get-conf-clusters.sh
# Cat Chenal @ Gunner Lab; 2010-08-26
#
# Purpose:      To obtain distance info from a given anchor (x,y,z) coords.
#
# Inputs:       1) input pdb file (step2_out format)
#               2-4) (x,y,z) coordinates of conf (or any other position) of interest
#
Usage: `basename $0` S2-conf.pdb 14.000 -6.800 40.800
#  ----------------------------------------------------------------------------

if [ $# < 5 ]
then
  echo "  Script `basename $0` requires a pdb file and an anchor coordinates as inputs."
  echo "  Call example: > echo $usage
  echo "--- `basename $0` ---  Call error  --- over."

else
  inpdb=$1
  outpdb="clus_"$1
  infofile="clusters.info"
  inX=$2
  inY=$3
  inZ=$4
 
#  export column_number
#  awkscript='{ total += $ENVIRON["column_number"] }
#  END { print total }'
# Now, run the awk script.
#  awk "$awkscript" "$filename"

# col 6, 7, 8 = x, y, z in step2
  export inX inY inZ
  line0="nawk '{d=0; {d=sqrt((X-$6)^2 + (Y-$7)^2 + (Z-$8)^2)}; {\$(NF+1)=d; OFS = "\t"; print }}' $inpdb  > $outpdb"

  line1=${line0//X/$3}
  line2=${line1//Y/$4}
  awkline=${line2//Z/$5}
  
  set `cat $inpdb`
  args=("$@")
  #for ( i = 0; i < $#; i++ ); do
    ID= ${args[${i}]}


  echo "X, Y, Z: " $X $Y $Z
  echo "$awkline"

# col 6, 7, 8 = x, y, z in step2
#
# nawk '{d=0; {d=sqrt((14.000-$6)^2 + (-6.800-$7)^2 + (40.800-$8)^2)}; {dist=(NF+1);$dist=d; OFS = "\t";print }}' CL-S2.pdb >clus-temp; head clus-temp 
#  nawk '{d=0; {d=sqrt(("$X"-$6)^2 + ("$Y"-$7)^2 + ("$Z"-$8)^2)}; {$(NF+1)=d; OFS = "\t"; print }}'  $inpdb > $outpdb

  echo ""
  echo "--- $this --- over."
fi
