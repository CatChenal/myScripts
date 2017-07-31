#!/bin/sh
# Cat Chenal 2011-08-02
#
USAGE="Argument(s) for this procedure: specific value(s) of pH/Eh whose mostocc pdb is wanted; if none specified, all titration points are used."

Col=1
awkscript=""
fldr=""
values=""
lastarg=""
ltr=""

for fldr in `ls -l | grep '^d' | awk '{print $NF}' | grep '^cl'`
do
  cd $fldr
  echo Folder: $fldr

  if [ ! -f "fort.38" ]
  then
    echo "Missing fort.38 (required) in $fldr"
    break		#exit 0
  fi
  head -1 fort.38 > fort.38.hdr

  if [ $# -eq 0 ]; then
    values=`cat fort.38.hdr| sed 's/ [pe]h              //'`
  else
# check if last arg is a letter:
#  if yes then this arg must be passed to mcce2pdb.sh
  lastarg=${!#}
  if [[ $lastarg =~ [a-zA-Z]* ]]; then
    ltr=$lastarg
     values="$@"
    #:: ph or eh value(s) passed as arg
  fi
  echo "Most occ points to retrieve: $values"

  for pH in $values
  do
    export pH
    awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
    Col=`nawk -v col="$pH" "$awkscript" "fort.38.hdr"`
    getmostocc.py $Col > $fldr-occph$pH

# Note below: mcce2pdb.sh w/o second arg: do not change the chain letter.
    mcce2pdb.sh $fldr-occph$pH
#    /bin/rm $fldr-occph$pH
  done
  cd ../
done
echo `basename $0`" Done!"
