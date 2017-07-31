#!/bin/sh

# Scriptname: getallpks.sh
# Cat Chenal @ Gunner Lab; 2010-06-16
#
# Purpose:      Creates a sorted datafile for all pkas in subfolders;
#
# Inputfile:	None directly, but pK.out must exist.
# Arguments:    1.  ANY character (i.e. "x" or "*/"): when the script is called from a folder
#		that contains a collection of mcce working directories (i.e. path = */).
#               working directories
#		2.  NONE (no argument): when the script is called inside the mcce working
#               directory.
# Output:	CSV file of pka values combined & sorted from all pK.out files
#		found in working subfolders (1.), or directory (2.);
#
# Usage1:	. getallpks.sh <any char>	# Uses */pK.out
# Usage2:	. getallpks.sh <no arg>	        # Uses ./pK.out
#  ----------------------------------------------------------------------------

this="getallpks.sh"
tmp1="pks.temp1"
tmp2="pks.temp2"
chis="highchires.csv"

flag="0"
if [ $# == 0 ]; then
  pkfile="pK.out"
  outfile="pks.csv"
else
  pkfile="*/pK.out"
  outfile="allpks.csv"
  flag="1"
fi

egrep 'ARG|ASP|CYS|GLU|HIS|LYS|TYR' $pkfile | gawk '{if ($2 =="pKa") print $1, $7, $7, $7; else print $1, $2, $3, $4}' > $tmp1

if [ $flag == 1 ]; then
   sed -n 's/\/pK.out:/ /p' $tmp1 | sed -e 's/[A-D]0/&      /' -e 's/0      /       /'  -e 's/_//' > $tmp2
else
   sed -e 's/[A-D]0/&      /' -e 's/0      /       /'  -e 's/_//' $tmp1 > $tmp2
fi

echo  --- $this ---  Remove "out of range" lines? \(y\/n\)?
read reply
if [ "$reply" = "y" ]; then
    egrep -v 'range' $tmp2 > $tmp1
    /bin/mv $tmp1 $tmp2
fi

# sort:
if [ $flag == 1 ]; then
  gawk 'BEGIN{OFS="\t";print "chain	res	seq	pKa	slope	1000*chi2"}{print $1, $2, $3, $4, $5, $6|"sort +2 -3 +3 -4 +0 -1"}' $tmp2 > $outfile
else
  gawk 'BEGIN{OFS="\t";print "res     seq     pKa     slope   1000*chi2"}{print $1, $2, $3, $4, $5|"sort +1 -2 +2 -3 +0 -1"}' $tmp2 > $outfile
fi
/bin/rm $tmp2
/bin/rm $tmp1

echo  --- $this ---  Output high chi sq \(\> 2.0\) residues in separate file? \(y\/n\)?
read reply
if [ "$reply" == "y" ]; then
  if [ $flag == 1 ]; then  
    gawk '{if ($3 == "seq"|| $6 > 2.000) print $0}' $outfile > $chis
  else
    gawk '{if ($2 == "seq"|| $5 > 2.000) print $0}' $outfile > $chis
  fi
fi

echo  --- $this ---  The output file is $outfile:
awk '{print $0}' $outfile
if [ "$reply" = "y" ]; then
  echo  --- $this ---  The high chi sq file is $chis:
  awk '{print $0}' $chis
fi
echo  --- $this over
