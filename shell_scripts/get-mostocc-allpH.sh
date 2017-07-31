#!/bin/bash
# ***  To be called INSIDE a working folder
# Argument(s): [outputfile prefix], default= folder name

if [ ! -f "fort.38" ]
then
  echo "Missing fort.38 (required)"
  exit 1
fi
if [ ! -f "fort.38.hdr" ]
then
    head -1 fort.38 > fort.38.hdr
fi

Col=1
Outfile=""
here=`pwd`
awkscript=""
prefix=""

if [ $# -eq 1 ]; then
  prefix=$1
fi
fldr=$prefix"-"`basename $here`

values=`cat fort.38.hdr| sed 's/ [pe]h              //'` #pH or Eh value(s)
#echo "Most occ points to retrieve: $values"

for pH in $values
do
  export pH
  # awk '{ for(n=1;n<=NF;n++) {if ( $n == "5.0" ) print n } }' fort.38.hdr
  # ph              0.0   1.0   2.0   3.0   4.0   5.0   6.0   7.0   8.0
  #  1              2     3     4     5     6     7     8     9     10
  # => n=7, so index for getmostocc.py = 6
  #
  awkscript='{ for(n=1;n<=NF;n++) {if ( $n == col ) print n } }'
  Col=`awk -v col="$pH" "$awkscript" "fort.38.hdr"`

  Outfile=$fldr"-pH"$pH
#  echo "pH: $pH -> $Col"
  unset pH

  getmostocc.py $Col > $Outfile
  mcce2pdb.sh $Outfile

#  mv $Outfile $Outfile".pdb"
#  /bin/rm $Outfile
done

