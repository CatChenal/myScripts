#!/bin/bash
# To obtain a list for the most occupied conf of the given residue number (nnnn) at all pH/eh values.
# Arguments: Residue-number, output-file

here=`pwd`
parent=`basename $here`
RES=$1
Outfile=$2
awkscript1=""
awkscript2=""
prevOcc=""
prevFldr=""
OutValues=""

for subfldr in `echo cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111`
do
  cd $subfldr
  head -1 fort.38 > fort.38.hdr
  values=`cat fort.38.hdr | sed 's/^ [e|p]h//'`

  for pH in $values
  do
    export pH
    awkscript1='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
    Col=`awk -v col="$pH" "$awkscript1" "fort.38.hdr"`
    awkscript1=""
    awkscript1='{ print $1"\t"$col }'
    awkscript2='NR==1 {print $1}'
    export Col
    mostocc=`grep "$RES" fort.38 |awk -v col="$Col" "$awkscript1" |sort -r -k2|awk "$awkscript2"`

    if [[ $subfldr != $prevFldr ]] && [[ $prevFldr != "" ]]; then
	OutValues=""
    fi

    if [[ $mostocc != $prevOcc ]] && [[ $prevOcc != "" ]] && [[ $OutValues != "" ]]; then
        echo    $subfldr" "$prevOcc" "$OutValues >> ../../$2
	OutValues=$pH";"
    else
        OutValues=$OutValues$pH";"
    fi
    prevOcc=$mostocc
    prevFldr=$subfldr
  done
  echo    $subfldr" "$prevOcc" "$OutValues >> ../../$2
  cd ../
done
#sed -i 's/1.5;2.0;2.5;3.0;3.5;4.0;4.5;5.0;5.5;6.0;6.5;7.0;7.5;/all/' $2
