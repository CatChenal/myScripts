#!/bin/bash
# To get small file reflecting mfe++ cutoff
# Called by: get_CL_energies.sh, get_RES_energies.sh, get_sum_h3tot.sh
#
if [[ $# -eq 0 ]]; then
  echo "The required arguments(up to 2) are those of mfe++: conf_id [cutoff: 1 if not included]"
  exit 0
fi
conf=$1
lim=1 	# 0.5=default cutoff in mfe++
if [[ $# -eq 2 ]]; then
  lim=$2
fi

out=$conf".sm_mfe.csv"
mfe++ $conf -x $lim -t $lim | sed -e 's/-0\.0/ 0\.0/g' > $conf".sm_mfe.csv"

#sed -i '/SUM/q' $conf".sm_mfe.csv"
/bin/rm -f $conf".mfe"
