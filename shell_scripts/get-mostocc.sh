#!/bin/sh
# ***  To be called INSIDE a working folder
# Argument(s) for this procedure: value(s) of pH/Eh whose mostocc pdb is wanted
# Note that the argument for mostocc.py is the col of pH/Eh in fort.38: always changing.

if [ ! -f "fort.38" ]
then
  echo "Missing fort.38 (required)"
  exit 1
fi

Col=1
Outfile=""
here=$(pwd)
fldr=$(basename $here)
awkscript=""

if [ $# -eq 0 ]; then
    values=$(head -1 fort.38| sed 's/.h //')
else
    values="$@"
    #:: ph or eh value(s) passed as arg
fi
echo "Most occ points to retrieve: $values"

for pH in $values  #pH or Eh value(s)
do
  Outfile=$fldr"_"$pH

  awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
  Col=$(head -1 fort.38|nawk -v col="$pH" "$awkscript")

  getmostocc.py $Col > $Outfile
  mcce2pdb.sh $Outfile

done

