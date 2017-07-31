#!/bin/bash
#  Cat Chenal @ Gunner Lab - 2010-09-30
#  To obtain a vector from sum_crg at a particlar p/eH
#
if [[ $# -eq 0 ]]; then
  echo "---> Missing argument (p/eH value). Exiting."
  exit 0
fi
if [[ ! -f "sum_crg.out" ]]; then
 echo "---> Missing sum_crg.out. Exiting."
 exit 0
fi

here=$(pwd)
fldr=$(basename $here)
pH=$1
Outfile=$fldr-crgv-$pH'.csv'

Col=0;
# get ph_col:
awkARG='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
Col=$(head -1 fort.38 |sed 's/ ph /ph/'| awk -v col="$pH" "$awkARG")
if [[ $Col -eq 0 ]];then
  echo 'pH/Eh point '$pH' not found in fort.38'
else
  # first change conf id to standard (missing underscore if YMC used in S4):
  conf=$(grep '^[A-Z]' sum_crg.out|awk 'NR==1 {print $1}; {exit}')  # returns: ARG+_A0017_ or ARG (YMC)
  if [[ ${#conf} -eq 3 ]]; then
    sed -i 's/\(^.[A-Z][A-Z]\)./\1_/' sum_crg.out
  fi

 # if ( $1 == "SUM" ) { new="ZUM" } else {new=substr($1,1,3)"_"substr($1,6,4)"_"substr($1,5,1) };
  chn="A"; Out=$chn'_'$Outfile
  nawk -v col="$Col" -v ch="$chn" -v ph="$pH" 'BEGIN{OFS="\t"; tot=0; print "Res",ph} 
                                   $1 !~/ p| e|Tot|Net/{ if ($1 ~ "_"ch) { tot+=$col; 
                                                                           { if ($1 ~ /^_/) { ionConf=substr($1,1,3); ions+=$col } }; 
                                                                           print $1,$col } } 
                                   END{ { if (ionConf=="_CL") {Ions=-1*ions} else {Ions=ions} }; 
                                        print "Prot", tot-ions 
                                        print "Ions", Ions}' sum_crg.out > $Out
  Out=""
  chn="B"; Out=$chn'_'$Outfile
  nawk -v col="$Col" -v ch="$chn" -v ph="$pH" 'BEGIN{OFS="\t"; tot=0; print "Res",ph}
                                   $1 !~/ p| e|Tot|Net/{ if ($1 ~ "_"ch) { tot+=$col;
                                                                           { if ($1 ~ /^_/) { ionConf=substr($1,1,3); ions+=$col } };
                                                                           print $1,$col } }
                                   END{ { if (ionConf=="_CL") {Ions=-1*ions} else {Ions=ions} };
                                        print "Prot", tot-ions
                                        print "Ions", Ions}' sum_crg.out > $Out

fi
