#!/bin/bash
#  Cat Chenal @ Gunner Lab - 2001-09-14
#  To create a pdb file for each non0 conf [or 0-occ confs depending on 3rd arg] of the input res at the input ph/eh
#
this=$(basename $0)
here=$(pwd)
fldr=$(basename $here)

if [ $# != 3 ]; then
  echo "Missing argument. Exiting."
  echo "SCRIPT $this requires a 4-digit res seq identifier (e.g. 0054), a pH/eh value, and"
  echo " a flag to output either non0 (t) or 0-occ (f) conformers. Example:"
  echo "> $this 0054 4.5 t   # returns all non0-occ conformers of res 0054"
  echo "> $this 0054 4.5 f   # returns all 0-occ conformers of res 0054"
  exit 0
fi

if [ $3 != "t" -a $3 != "f" ]; then
 echo "Wrong flag: t = non0-occ conformers; f = 0-occ conformers."
 exit 0
fi

RES=$1
pH=$2
flag=$3
Col=1
Outfile=""
bkb=""
conf=""
awkscript=""
resfile=""
echo "Splitting confs of $RES at $pH"

 # Get BKB atoms > RES.bkb:
 bkb="$RES"_000
 grep $bkb step2_out.pdb > bkb.tmp

 # Get column number from given ph/eh:
 head -1 fort.38 > fort.38.hdr
 export pH
 awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
 Col=`nawk -v col="$pH" "$awkscript" "fort.38.hdr"`

 # Get confs of RES at given pH & get non0 confs:
 export Col
 if [ "$flag" == "t" ]; then
   resfile=$fldr-$RES-non0.38
   grep $RES fort.38 | nawk -v col="$Col" '{ print $1"\t"$col }' | grep -v 0.00 | cut -c7-14 > $resfile
 else
   resfile=$fldr-$RES-0.38
   grep $RES fort.38 | nawk -v col="$Col" '{ print $1"\t"$col }' | grep 0.00 | cut -c7-14 > $resfile
 fi
 
for conf in `cat $resfile`
 do
 #  echo "pH: $pH -> $Col; Output: $Outfile"
   grep $conf step2_out.pdb > conf.tmp
   if [ "$flag" == "t" ]; then
     Outfile=$fldr-$conf-non0-pH$pH
   else
     Outfile=$fldr-$conf-0-pH$pH
   fi

   cat bkb.tmp conf.tmp > $Outfile
   /bin/rm conf.tmp
   mcce2pdb.sh $Outfile
   /bin/rm $Outfile
 done
 /bin/rm *tmp
