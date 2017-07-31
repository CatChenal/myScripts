#!/bin/bash
here=$(pwd)
here=$(basename $here)
echo "Current dir: "$here
if [[ $# -ne 3 ]]; then
  echo "get-HBcontact-res.sh <fldr_startwith> <RES> <cutoff>"
  exit 0
fi
startwith=$1
RES=$2
cutoff=$3 #(angstroms)
#............................................................................
for dir in $(ls -l | grep ^d | grep "$startwith" |awk '{print $NF}')
do
  fldr=$dir"/new"
  cd $fldr

  if [[ ! -f "fort.38" ]]; then
   echo "No fort.38 in "$fldr
   cd ../../
   continue
  fi

  #  fldr="GlpT-2_nn/new" => remove slashes
  outfile=${fldr////-}"-res-"$cutoff"A.csv"
  if [[ -f "$outfile" ]]; then
    /bin/rm $outfile  # rm previous occurrence
  fi
  touch $outfile

  if [[ ! -f "fort.38.non0" ]]; then
    getnon0rows.sh fort.38
  fi
  mostocc=$(basename $fldr)"-pH7.PDB"
  if [[ ! -f "$mostocc" ]]; then
    get-mostocc.sh 7 # output saved as <parent-fldr.-pH7.PDB
  fi

  # Extract col of pH7 in fort.38:
  Col=$(head -1 fort.38 | nawk -v ph="7.0" '{ for(n=2;n<=NF;n++) {if ( $n == ph ) print n} }')
  # get mostocc H165:
  mostH165=""
  mostH165=$(egrep 'HIS...0165' fort.38.non0 | nawk -v occCol="$Col" '{print $1"\t"$occCol}'|sort -k2n|tail -1| nawk '{print substr($1,1,5)"_"substr($1,8,3)}')
  if [[ ! ${#mostH165} ]]; then
    mostH165="None"
  fi

  # mostocc.PDB format:
  #ATOM  38984  CZ  PHE P 203      16.471   7.213  -4.946   1.7
  #1     2      3   4   5 6        7        8      9

# Next: different processing depending on valence:
  if [[ "$RES" =~ "CL" ]]; then
    # grep anchor from parent, extract X Y Z
    AnchorLine=$(grep CL $mostocc | nawk ' {print}')

    if [[ ${#AnchorLine} ]]; then
      X=$(echo $AnchorLine | awk '{print $7}')
      Y=$(echo $AnchorLine | awk '{print $8}')
      Z=$(echo $AnchorLine | awk '{print $9}')

      # compute distance and extract list of res within cutoff A of anchor:
      nawk -v x="$X" -v y="$Y" -v z="$Z" -v max="$cutoff" -v dir="$fldr" -v HIS="$mostH165" 'BEGIN{OFS="\t"}
           { if ($4 !~ "CL"){dist=sqrt( (x-$7)^2 + (y-$8)^2 + (z-$9)^2 ); { if (dist<=max) { print dir,HIS,"Cl-1","CL",$4"_"$5"_"$6,dist }}} }' $mostocc >> $outfile
    else
      echo "No CL in mostocc of "$fldr
    fi

  else #assumed PO4

    if [[ -f "most.tmp" ]]; then
      /bin/rm most.tmp
    fi
    # get mostocc Pi:
    mostPi=""
    mostPi=$(egrep PO4 fort.38.non0 | nawk -v occCol="$Col" '{print $1"\t"$occCol}'|sort -k2n|tail -1| nawk '{print substr($1,1,5)"_"substr($1,8,3)}')
    if [[ ${#mostPi} ]]; then

      touch most.tmp
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
          nawk -v x="$X" -v y="$Y" -v z="$Z" -v max="$cutoff" -v dir="$fldr" -v Pi="$mostPi" -v HIS="$mostH165" -v i="$n" 'BEGIN{OFS="\t"}
            { if ($4 != "PO4") { dist=sqrt( (x-$7)^2 + (y-$8)^2 + (z-$9)^2 ); { if (dist <= max) { print dir,HIS,Pi,"O"i,$4"_"$5"_"$6,dist }}} }' $mostocc >>  $outfile  ## most.tmp
        else
          echo "Problem getting AnchorLine for "$RES" in "$fldr
        fi
      done
# NEEDS WORK::
      # Keep shortest dist from PO4_O atm:
#       nawk 'BEGIN{OFS="\t"; prevFldr=""; prevRes=""; prevDist=""; prevLine=""}
 #           { if (NR==1){ prevFldr=$1; prevRes=$5; prevDist=$6; prevLine="|"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"|" } }
 #           { while($1==prevFldr) { if ($5 == prevRes) { if ($6 <=prevDist) { prevDist=$6;prevFldr=$1; prevRes=$5; prevDist=$6; prevLine="|"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"|" } }
 #                                                                      else { print prevLine } };
 #                                   prevFldr=$1; prevRes=$5; prevDist=$6; prevLine="|"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"|"  ; exit }' most.tmp | sed 's/|//g'  most.tmp > $outfile
    else
       echo "No "$RES" in mostocc of "$fldr
    fi
  fi
  cd ../../
done

# Combine all frames & insert header:
cat $startwith*/new/*"-res-"$cutoff"A.csv" | sort -k1 -k5 -k6n| sed '1i dir      occH165	occAnchor       atmAnchor       Res     dist_anchor'  > $here"-new-allframes-res-"$cutoff"A.csv"
