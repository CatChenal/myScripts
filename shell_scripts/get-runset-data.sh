#!/bin/bash
# catalys 2013-09-06
# Wrapper for get-runset-crg-aver-std.sh
# Keyres are hard-coded
#
if [[ $# -eq 0 ]]; then
  echo "1st arg: regex for folder selection [2nd arg: subfolder to process the same way]"
  exit 1
fi
fldr_select=$1
awkscript=' $NF ~ crit {print $NF} '

for dir in $(ls -l|grep ^d| awk -v crit="$fldr_select" "$awkscript")
do
  # Note: $(ls -l|grep ^d| nawk '$NF ~ /R0.00/ {print $NF}'): works
  #  => for dynamical regex, the flanking slashes must be removed
 echo $dir

 cd $dir
   BEF=${dir%R*}
   AFT=${dir##*-}
   rlx=${AFT:2:1}
   pref=$BEF"R"$rlx
   #echo $pref
   # " ARG: prefix (str) of output file names; 4 digit residue id(s)"

   get-runset-crg-aver-std.sh $pref 0113 0148 0203

   if [[ $# -eq 2 ]]; then
     if [[ -d $2 ]]; then
       cd $2
       newpref=$pref"-"$2  # prefix for new output
       get-runset-crg-aver-std.sh $newpref 0113 0148 0203
       cd ../
     fi
   fi
 cd ../

done
