#!/bin/bash
# ***  To be called INSIDE a working folder
ARGS="Optional argument: [new chain letter]"
# Note that the argument for mostocc.py is the col of pH/Eh in fort.38: always changing.
# New chain ltr is hardcoded in the mcce2pdb.sh line
#
Col=1
Outfile=""
EXT="ph"        # Could be changed to eH
here=`pwd`
fldr=`basename $here`
awkscript=""
ltr=""

if [ ! -f "fort.38" ]
then
  echo "Missing fort.38 (required)"
  exit 1
fi
head -1 fort.38 > fort.38.hdr
values=`cat fort.38.hdr | sed 's/ [pe]h              //'`

if [ $# -eq 1 ]; then
#  if [[ "$1" =~ "^[a-zA-Z]*" ]]; then #does not work
   ltr=$1
#  fi
else
  echo "$ARGS"
  exit 1
fi
echo "Most occ points to retrieve: $values; New chain ltr: $ltr"

for pH in $values  #pH or Eh value(s)
do
  export pH
  awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
  Col=`nawk -v col="$pH" "$awkscript" "fort.38.hdr"`

  Outfile=$fldr-$EXT$pH
  getmostocc.py $Col > $Outfile
  mcce2pdb.sh $Outfile $ltr
  /bin/rm $Outfile
done

