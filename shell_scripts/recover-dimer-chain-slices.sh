#!/bin/bash
# To use when pdb from MD sim has the same chain ltr (non-null char)
#..................................
tot=0
for dimer in $(ls |grep sliceAB)
do
  echo $dimer
#  CL_cnt=$(grep CL $dimer|wc -l)	# = number of CL in chain A
# problem with CL count: not the same in all files + unven

#  is_even=$(($CL_cnt%2))
#  if [ $(($CL_cnt%2)) -eq 0 ]; then
#   (( tot++ ))
#    echo $dimer": "$CL_cnt
#    grep CL $dimer
#   echo
#[catalys@sibyl Dimer_slices]> grep CL sliceAB-21-dry.pdb
#ATOM   7075  CL  _CL B 466      13.221  13.860   0.631  0.00  0.00      O65: cA
#ATOM  13848  CL  _CL B 466     -14.063 -14.192   3.659  0.00  0.00      O66
#ATOM  15826  CL  _CL B  30      27.880  19.183  17.736  0.00  0.00      O67
#ATOM  15827  CL  _CL B  33      22.987  -2.470  17.311  0.00  0.00      O67
#ATOM  15828  CL  _CL B  41     -23.127  -1.747  17.994  0.00  0.00      O67
#ATOM  15829  CL  _CL B  44     -24.400 -17.249  15.685  0.00  0.00      O67
# [catalys@sibyl Dimer_slices]> grep CL sliceAB-03-dry.pdb
#ATOM   6979  CL  _CL B 466      14.601  13.112   2.167  0.00  0.00      O65
#ATOM  13761  CL  _CL B 466     -15.115 -12.646   1.929  0.00  0.00      O66
#ATOM  15626  CL  _CL B  28     -25.409 -17.359  13.840  0.00  0.00      O67
#  => if $7>0 then $5="A"
# fi

  # Change chain letter to B (all):
  sed -i 's/B   /O   /; s/ P / B /; s/CL O/CL B/' $dimer

  # Recover chain A:  CLC 1OTS cA: res 17 to 460
  # Get record number for last res of cA:
  cA_end=$(awk '/B 460/{print NR}' $dimer | tail -1)
  #echo "cA_end: "$cA_end

  awk -v eoA="$cA_end" 'BEGIN{ prtPDB="%-6s%5d  %-3s %3s %c%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n"} \
                     { i=NR; \
                       for (i=NR; i<=eoA; i++) { $5="A"}; if($3=="CL") {if ($7>0) { $5="A"} }; \
                       printf prtPDB,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11  \
                     }' $dimer > tmp

  /bin/rm $dimer
  mv tmp $dimer
done
#echo "Total dimer pdbs with even count of CLs: " $tot
