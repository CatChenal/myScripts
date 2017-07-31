#!/bin/bash
this=$(basename $0)
cutoff=18 #(angstroms)
if [[ $# -ne 1 ]]; then
  echo $this": Start of pdb filenames to process required. None given. Exiting..."
  exit 0
fi
#startwith="clusterAB-"
startwith=$1
echo $this":  Processing dimer files that start with '$startwith' with a sphere radius of '$cutoff'A from CL A/B 466 (central CL): ok? [1/0]"
read reply
if [[ $reply -eq 0 ]]; then
  exit 0
fi
#............................................................................
prt12="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"
#............................................................................
for hohpdb in $(ls "$startwith"*-wat.pdb)
do
  # water lines coming from rename-dup-waters script all have 11 fields:
  # Before:
  # 1     2     3    4   5 6        7       8      9        10    11        12
  # ATOM      8 1H   HOH W 602     -13.761  17.644 -19.922  0.00  0.00      W2
  # After:
  # ATOM  15768 2H   HOH x0602      14.561  15.281 -13.635  0.00  0.00      W23
  # 1     2     3    4   5          6       7       8       9     10        11

  dry=${hohpdb/%-wat.pdb/-dry.pdb}
#  ./convert-to-pdb.sh $dry
  # [catalys@sibyl Dimer_slices]> grep CL clusterAB-30-dry.pdb
  # ATOM   7021  CL  _CL A 466       4.902   5.124   1.341  0.00  0.00      P1
  # ATOM  13800  CL  _CL B 466     -23.520 -22.651   2.026  0.00  0.00      P2
  # ATOM  15708  CL  _CL B  30     -33.277 -31.765  14.850  0.00  0.00      P2

  # chain ltr = A, B:
  CL466found=0
  CLline1=$(grep 'CL A 466' $dry)
  if [[ ${#CLine1} ]]; then
    # grep CL466 from parent, extract X Y Z
    X1=$(echo $CLline1 | awk '{print $7}')
    Y1=$(echo $CLline1 | awk '{print $8}')
    Z1=$(echo $CLline1 | awk '{print $9}')
#    echo " CL A466: "$X1", "$Y1", " $Z1
    CL466found+=1
  fi
  CLline2=$(grep 'CL B 466' $dry)
  if [[ ${#CLine2} ]]; then
    # grep CL466 from parent, extract X Y Z
    X2=$(echo $CLline2 | awk '{print $7}')
    Y2=$(echo $CLline2 | awk '{print $8}')
    Z2=$(echo $CLline2 | awk '{print $9}')
#    echo " CL B466: "$X2", "$Y2", " $Z2
    CL466found+=1
  fi
  if [[ $CL466found -gt 0 ]]; then

    hohredid=${hohpdb/%-wat.pdb/-wat18A.ids}
    /bin/rm -f $hohredid  # rm previous occurrence

    # compute distance and extract list of wire hoh within 18A of CL anchor:
    nawk -v x1="$X1" -v y1="$Y1" -v z1="$Z1" -v x2="$X2" -v y2="$Y2" -v z2="$Z2" -v max="$cutoff" \
         '{ dist1=sqrt((x1-$6)^2 + (y1-$7)^2 + (z1-$8)^2); dist2=sqrt((x2-$6)^2 + (y2-$7)^2 + (z2-$8)^2); \
            { if ( (dist1<=max)||(dist2<=max) ) { print $5 } } }' $hohpdb |uniq > $hohredid

#    nawk -v x1="$X1" -v y1="$Y1" -v z1="$Z1" -v x2="$X2" -v y2="$Y2" -v z2="$Z2" -v max="$cutoff" \
#        '{ if ($5=="A") { dist1=sqrt((x1-$6)^2 + (y1-$7)^2 + (z1-$8)^2); { if (dist1<=max) { print $5 }} } \
#                   else { dist2=sqrt((x2-$6)^2 + (y2-$7)^2 + (z2-$8)^2); { if (dist2<=max) { print $5 }} } }' $hohpdb |uniq > $hohredid

      if [ -s $hohredid ]; then

        hohred=${hohpdb/%-wat.pdb/-wat18A.pdb}
        # get waters pdb lines from list of wat in 18A-sphere  above (hohredid):
        run-egrepline-from-list.sh $hohredid $hohpdb tmp

        awk -v fmt12="$prt12" \
            '{ if ( length($3)< 4 ) {atm=sprintf(" %-3s",$3)} else {atm=$3}; \
               { if (NF==11) { chn=substr($5,1,1); seq=substr($5,2,4) } else { chn=$5; seq=$6 } }; \
               { if (NF==11) { printf(fmt12,$1,$2,atm,$4,chn,seq,$6,$7,$8,$9,$10,$11) } \
                        else { printf(fmt12,$1,$2,atm,$4,chn,seq,$7,$8,$9,$10,$11,$12) } } } ' tmp > $hohred

      fi
      /bin/rm -f tmp $hohredid
  else
   echo "No Cl found in "$dry
  fi #if CL
done
