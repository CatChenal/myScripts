#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo $(basename $0)" RES (any portion of the 10-char conf_name, eg: GLU02A0190 or -1A0190); fav_only (0/1) (outputs confs w/negative h3_tot only) [ /path/head3.lst ]"
  exit 0
fi
# Conformer name length in head3: GLU02A0190 = 10 char
RES=$1
fav_only=$(echo "scale=0; $2*1" | bc)

H3File="head3.lst"
if [[ $# -eq 3 ]]; then
  H3File=$3
fi

outfile=$RES"_mostfav.csv"

# iConf CONFORMER     FL  occ    crg   Em0  pKa0 ne nH    vdw0    vdw1    tors    epol   dsolv   extra    history
# 00001 ARG01A0017_001 f 0.00  0.000     0  0.00  0  0  -4.740   3.551   0.996  -1.997   2.285   0.000 01O000M000
# 1     2             3  4     5       6    7    8   9   10       11     12     13       14      15    16

# get sorted data:
if [[ $fav_only -eq 0 ]]; then
  strAWK='/'$RES'/ { tot=$(NF-6)+$(NF-5)+$(NF-3)+$(NF-2); printf("%14s %8.3f %8.3f %8.3f %8.3f %10.3f\n", $2,$(NF-6),$(NF-5),$(NF-3),$(NF-2),tot) }'
  nawk "$strAWK" $H3File > $outfile
else
  strAWK='/'$RES'/ { tot=$(NF-6)+$(NF-5)+$(NF-3)+$(NF-2); if (tot<0) {printf("%14s %8.3f %8.3f %8.3f %8.3f %10.3f\n", $2,$(NF-6),$(NF-5),$(NF-3),$(NF-2),tot) }}'
  nawk "$strAWK" $H3File | sort -k6n > $outfile
fi

h3head=$(nawk 'NR==1 { printf("%-14s %8s %8s %8s %8s %8s\n", $2,$(NF-6),$(NF-5),$(NF-3),$(NF-2),"h3Tot") }' $H3File)
strSED='1i '$h3head
sed -i "$strSED" $outfile

#cat $outfile
echo 'h3_mostfav.sh Output: '$outfile
echo
