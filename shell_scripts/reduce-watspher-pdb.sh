#!/bin/bash
# PDBformat="%-6s%5d%5s%5s%2s  %8.3f%8.3f%8.3f%8.3f%12.3f%16s %4.2f\n"
# Water only DIMER file expected & already 'cleaned up' version - no dups - from MD < rename-slices.sh

if [ $# -lt 1 ]; then
  echo $0": Missing input: pdb file needed."
  exit 0
elif [ ! -f "$1" ]; then
  echo $0": Input not a file."
  exit 0
else
  hohpdb=$1
  if ! [ ${hohpdb##*-} = "wat.pdb" ]; then
     echo $0": Input file must be a water file created by calling script rename-slices.sh."
    exit 0
  fi
fi

cutoff=23 #(angstroms)
wat_end="-wat"$cutoff"A.pdb"
ids_end="-wat"$cutoff"A.ids"

pdb=${hohpdb//-wat.pdb/-dry.pdb}
sphrpdb="wat"$cutoff"-"${hohpdb//-wat.pdb/.pdb}
#............................................................................
  hohred=${hohpdb/%-wat.pdb/$wat_end}
  hohredid=${hohpdb/%-wat.pdb/$ids_end}
  # pad id_num with 0 as in s2.pdb so that NF=11:
  # 1         2   3  4   5 6        7      8        9
  # ATOM      1    O HOH W 106      -3.118 -38.328  20.323  0.00  0.00       W2
  # ATOM      2   1H HOH W1106      -2.853 -37.696  19.628  0.00  0.00       W2
  # 1         2   3  4   5          6        7      8
  sed -i 's/W   \([1-9]\)/W000\1/;s/W  \([1-9][1-9]\)/W00\1/;s/W \([1-9][1-9][1-9]\)/W0\1/' $hohpdb

  # anchor = OG of S107 ion of each chain A.B (hard coded)
  anchorline=$(grep 'SER A 107' $pdb|grep OG)
  if [[ ${#anchorline} ]]; then
    X1=$(echo $anchorline | awk '{print $7}')
    Y1=$(echo $anchorline | awk '{print $8}')
    Z1=$(echo $anchorline | awk '{print $9}')
    echo "S107a: "$X1" "$Y1" "$Z1
  else
    echo "S107 OG of chain A not found"
    exit 0
  fi
  anchorline=$(grep 'SER B 107' $pdb|grep OG)
  if [[ ${#anchorline} ]]; then
    X2=$(echo $anchorline | awk '{print $7}')
    Y2=$(echo $anchorline | awk '{print $8}')
    Z2=$(echo $anchorline | awk '{print $9}')
    echo "S107b: "$X2" "$Y2" "$Z2
  else
    echo "S107 OG of chain B not found"
    exit 0
  fi

  # compute distance and extract list of wire hoh within cutoff dist of anchor:
  nawk -v x1="$X1" -v y1="$Y1" -v z1="$Z1" -v x2="$X2" -v y2="$Y2" -v z2="$Z2" -v max="$cutoff" \
      '{ d_C1=sqrt( (x1-$6)^2 + (y1-$7)^2 + (z1-$8)^2 ); d_C2=sqrt( (x2-$6)^2 + (y2-$7)^2 + (z2-$8)^2 ); \
         { if ( (d_C1<=max)||(d_C2<=max) ) { print substr($5,1,5) }} \
       }' $hohpdb |uniq > $hohredid

  if [ -s $hohredid ]; then
    # get waters pdb lines from list of wat in cutoff sphere above (hohredid):
    run-egrepline-from-list.sh $hohredid $hohpdb $hohred
  fi
  cat $pdb $hohred > $sphrpdb
  /bin/rm $hohredid
