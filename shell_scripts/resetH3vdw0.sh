#!/bin/bash
DO_WHAT='To set vdw0 of ion DM conf with -0.06*SAS(ion_rad only)'

if [[ $# -lt 2 ]]; then
  echo 'Missing name of dummy_conf and vdw0 value to set.'
  echo 'Purpose: '$DO_WHAT
  exit 85
fi
ion_DM=$1  #e.g. CLDM
vdw0_DM=$2

grep -v CONF head3.lst > head3.tmp1
# awk '/CLDM/{$10=sprintf("%8.3f",0)}; /CL-1/{$10=sprintf("%8.3f",-2.443)}; {print}' head3.lst.bkp > head3.lst

awk -v DM="$ion_DM" -v vdw0="$vdw0_DM" 'BEGIN{ h3PRT="%05d %s %c %4.2f %6.3f %5.0f %5.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n"; 
                                               h3HDR="iConf CONFORMER     FL  occ    crg   Em0  pKa0 ne nH    vdw0    vdw1    tors    epol   dsolv   extra    history"; 
                                               print h3HDR } 
                                        { if($2 ~ DM) { $10=vdw0 }; printf (h3PRT,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16) }' head3.tmp1 > head3.lst
/bin/rm head3.tmp1
echo "vdw0 of dummy '"$ion_DM"' set to "$vdw0_DM" on "$(date) > resetH3vdw0.info
