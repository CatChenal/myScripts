#!/bin/bash
## get-relativedist-Pi-H165.sh
here=$(pwd)
here=$(basename $here)
echo "Current dir: "$here
if [[ $# -ne 2 ]]; then
  echo "get-relativedist-Pi-H165.sh <fldr_startwith> <cutoff>"
  exit 0
fi
startwith=$1
cutoff=$2 #(angstroms)
#............................................................................y
for fldr in $(ls -l | grep ^d | grep "$startwith" |awk '{print $NF}')
do
  cd $fldr
  if [[ ! -f "fort.38" ]]; then
   echo "No fort.38 in "$fldr
   cd ../
   continue
  fi
  outfile=$fldr"-Pi-H165-"$cutoff"A.csv"
  if [[ -f "$outfile" ]]; then
    /bin/rm $outfile  # rm previous occurrence
  fi
  touch $outfile
  if [[ ! -f "fort.38.non0" ]]; then
    getnon0rows.sh fort.38
  fi
  mostocc=$fldr"-pH7.PDB"
  if [[ ! -f "$mostocc" ]]; then
    get-mostocc.sh 7 # output saved as $fldr-pH7.PDB
  fi

  # get mostocc Pi:
  mostPi=$(egrep PO4 $mostocc)
  if [[ ${#mostPi} ]]; then
  # mostocc.PDB format:
  #ATOM  38984  CZ  PHE P 203      16.471   7.213  -4.946   1.7
  #1     2      3   4   5 6        7        8      9

    # get O atoms of PO4 to use as anchors:
    for n in $(echo '1 2 3 4')
    do
      AnchorLine=$(egrep 'O'$n'  PO4' $mostocc | nawk ' {print}')
      if [[ ${#AnchorLine} ]]; then
        X=$(echo $AnchorLine | nawk '{print $7}')
        Y=$(echo $AnchorLine | nawk '{print $8}')
        Z=$(echo $AnchorLine | nawk '{print $9}')
        # echo $AnchorLine" : "$X", "$Y", "$Z
        # compute distance and extract list of res within cutoff A of anchor:
        nawk -v x="$X" -v y="$Y" -v z="$Z" -v dir="$fldr" -v max="$2" -v i="$n" 'BEGIN{OFS="\t"}
          { if ($4 != "PO4") { dist=sqrt( (x-$7)^2 + (y-$8)^2 + (z-$9)^2 ); { if (dist <= max) {$8=dist; { print dir, $3, $4"_"$5"_"$6, "O"i, $8 }}} }}' $mostocc >> $outfile
      else
        echo "Problem getting Pi AnchorLine in "$fldr
      fi
    done
  else
     echo "No occ'd Pi in mostocc of "$fldr
  fi
  cd ../
done
# Combine all frames:
cat $startwith*/$startwith*"-Pi-H165-"$cutoff"A.csv"  > $here"-all-Pi-H165-"$cutoff"A.csv"
#|sort -k1 -k5 -k6n | sed '1i dir      occAnchor       atmAnchor       occH165	Res     dist_anchor'  > m

