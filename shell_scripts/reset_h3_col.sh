#!/bin/bash
# Cat Chenal @ Gunner Lab
#
# Used to rest a given column from head3.lst wih a given value for all or many subset of residues;
# (If the input file is a copy of head3.lst, it must also contain the header line.)
#
# The column to amend in head3.lst is passed using its header name e.g. tors;
# The amended file is saved as [given input filename].new;
#
# Refinement (to do):
#   Allow res_name to be a regex string or complete if_statement for CONFORMER field of head3.lst, e.g. 'ASP|GLU'
#   Until that is done, to change all ASP and GLU, one would have to run it with one of them and
#   used the resulting ".new" file as input when doing the other, so that the final ".new.new" file would
#   have both ASP and GLU conformers reset (possibly with different column and or new value).
#............................................................................................................
Usage="USAGE: reset_h3_col.sh h3-file col_name col_value [res_name]"
# Possible format for res-name:
# XXX01C0nnn_nnn : len = 14 => specific residue conf
# XXX01C0nnn     : len = 10 => all neutral confs
# C0nnn          : len = 5  => all confs of resid 0nnn in chain C
# 0nnn           : len = 4  => all confs of resid 0nnn in all chains

# head3.lst header as of 2012-09-28:
HDR="iConf CONFORMER     FL  occ    crg   Em0  pKa0 ne nH    vdw0    vdw1    tors    epol   dsolv   extra    history"

if [ $# -lt 3 ]; then
  echo $Usage
  exit 0
fi
File=$1; Col=$2; Val=$3;

awkscript=' { for(n=3;n<=NF;n++) {if ( $n == col ) print n} }'
colnum=$(echo $HDR | nawk -v col="$Col" "$awkscript") ### h3.hdr)
export colnum Val HDR

echo "Master file: "$File"; Value to place in ["$Col"="$colnum"]: "$Val

# Build argument string for nawk:
if [ $# -eq 3 ]; then
  # reset col for all conformers:
  awkARGs='BEGIN { print hdr; h3format="%05d %s %c %4.2f %6.3f %5.0f %6.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n" } \
           NR>1 { $col=new; printf h3format, $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16 }'
  ##  nawk -v col="$colnum" -v new="$Val" '

elif [ $# -eq 4 ]; then

  which=$4
  export which
  len_which=${#which}
  ## echo "ARGs= "$#"; len[4]= "$len_which"; col_num: "$colnum

  if [[ $len_which -eq 14 ]]; then
    # exact conformer match:
    awkARGs='BEGIN { print hdr; h3format="%05d %s %c %4.2f %6.3f %5.0f %6.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n" } \
             NR>1 { { if ($2==res) {$col=new} }; printf h3format, $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16 }'

  else # any portion of it:
    awkARGs='BEGIN { print hdr; h3format="%05d %s %c %4.2f %6.3f %5.0f %6.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n" } \
             NR>1 { { if ($2~res) {$col=new} }; printf h3format, $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16 }'
  fi
fi

# Perform nawk operation:
nawk -v hdr="$HDR" -v col="$colnum" -v new="$Val" -v res="$which" "$awkARGs" $1 > $1.new
#    echo "awk args: "$awkARGs

# mv head3.lst head3.lst.bkp
# ln -s head3.lst.new head3.lst
# run S4
