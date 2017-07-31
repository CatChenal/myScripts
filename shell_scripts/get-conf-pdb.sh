#!/bin/bash
#
if [[ $# -lt 3 ]]; then
  echo "ARGs: 1) Res id (e.g. A0148); 2) Res type: a= acid, b=base; 3) state (1=neutral, 0=charged) [ 4) ion to include (e.g. _CL)]"
  echo "Note:  $(basename $0) exclude high-clash conformers (999.000 values). "
  exit 0
fi
here=$(pwd)
fldr=$(basename $here)
if [[ ! -f step2_out.pdb ]] || [[ ! -f head3.lst ]]; then
  echo " step2_out.pdb or head3.lst is not in this folder ("$fldr"), but is required."
  exit 0
fi
RES=$1; chn=${RES:0:1}; TYPE=$2; STATE=$3
# sta=$([ "$STATE" -eq 0 ] && echo "c" || echo "n")  # c=charged; n=neutral

if [[ "$STATE" -eq 1 ]]; then
  LIST=$fldr"_n_"$RES.lst
  if [[ $TYPE == "a" ]]; then
    grepARG=" -v '\-1"$RES"|999.000' "
  else
    grepARG=" -v '\+1"$RES"|999.000' "
  fi
  grep $RES head3.lst |eval egrep "$grepARG" | awk '{print substr($2,6,9)}' > $LIST
else
  LIST=$fldr"_c_"$RES.lst
  if [[ $TYPE == "a" ]]; then
    grepARG=" '\-1"$RES"' "
  else
    grepARG=" '\+1"$RES"' "
  fi
  eval egrep "$grepARG" head3.lst| grep -v '999.000' | awk '{print substr($2,6,9)}' > $LIST
fi

ARG1=" '"$RES"_000|"

if [[ $# -eq 4 ]];then
  ion=$4
  if [[ ${#ion} -eq 3 ]]; then
    ARG1=" '"$ion"|"$RES"_000|"
    ion2=${ion:1:2}
  else
    echo "Ion ID not 3 characters. Ignored."
  fi
fi
for conf in $(cat $LIST)
do
  grepARG=$ARG1$conf"' "

#ATOM   2075  HG2 GLU A 148       0.622   5.324  -3.038  1.00  0.00
#[catalys@sibyl cl000]> cat cl000_A0148_072.pdb
#ATOM  28061  N   GLU  A 148   1.644   8.110  -2.190   1.50
#ATOM  28062  H   GLU  A 148   2.157   7.597  -2.878   1.00
  if [[ $# -eq 4 ]];then
 #  sedARG=" -e 's/.\{30\}$//; s/_[0-9][0-9][0-9]/   /; s/"$ion"\( "$chn"\)/  "$ion2"\1/; s/\("$chn"\)0/\1 /;/"$ion"/d' "
    sedARG=" -e 's/.\{30\}$//; s/_[0-9][0-9][0-9]/   /; s/\("$RES"\)/\1 /;s/\("$ion" "$chn".... \)/\1    /;s/"$ion"\( "$chn"\)/ "$ion2"\1/;s/\("$chn"\)0/\1 /;/"$ion"/d' "
  else
    sedARG=" -e 's/.\{30\}$//; s/_[0-9][0-9][0-9]/   /; s/\("$chn"\)0/\1 /' "
  fi
  eval egrep "$grepARG" step2_out.pdb | eval sed "$sedARG" > $fldr"_"$conf.pdb
done
