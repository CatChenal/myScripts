#!/bin/bash
# To remove C-atoms from M chain (MEM res) that are erroneously placed in protein
# cavities by ipece add_membrane routine.
# -> Remove atoms in cylinder of radius 19 centered on E148
#.........................................................................
USAGE=$(basename $0)": 1st_chain_ltr [2nd_chain_ltr]"\n"Single character chain letter."
here=$(pwd)
dir=$(basename $here)
if [[ $# -eq 0 ]]; then
  echo "Up to 2 chain letters expected. None given. Exiting..."
  exit 0
elif [[ $# -gt 2 ]]; then
  echo "Implemented for 2 chains. Exiting..."
  exit 0
fi
 cutoff1=19 # for E148_Cb
 cutoff2=12 # for E203_Cb
 cutoff3=18 # for N318_Cg

  chn1=$1
  if [[ ${#chn1} -gt 1 ]]; then
    echo $USAGE" Exiting..."
    exit 0
  fi

  # Retrieve E148 coordinates for that chain:
  strGREP=""; strGREP=" 'CB  GLU "$chn1" 148 ' "
  E1_CB1=$(eval grep "$strGREP" prot.pdb)
  if [[ ${#E1_CB1} ]]; then
    e1X1=$(echo $E1_CB1 | awk '{print $7}')
    e1Y1=$(echo $E1_CB1 | awk '{print $8}')
    e1Z1=$(echo $E1_CB1 | awk '{print $9}')
    echo "E1_CB1 coords: "$e1X1" "$e1Y1" "$e1Z1
  else
    echo "E1_CB1 coords: not found. Exiting..."
    exit 0
  fi
  # Retrieve E203 coordinates for that chain:
  strGREP=""; strGREP=" 'CB  GLU "$chn1" 203 ' "
  E2_CB1=$(eval grep "$strGREP" prot.pdb)
  if [[ ${#E2_CB1} ]]; then
    e2X1=$(echo $E2_CB1 | awk '{print $7}')
    e2Y1=$(echo $E2_CB1 | awk '{print $8}')
    e2Z1=$(echo $E2_CB1 | awk '{print $9}')
    echo "E2_CB1 coords: "$e2X1" "$e2Y1" "$e2Z1
  else
    echo "E2_CB1 coords: not found. Exiting..."
    exit 0
  fi
  # Retrieve N318 coordinates
  strGREP=""; strGREP=" 'CG  ASN "$chn1" 318 ' "
  N318_CG1=$(eval grep "$strGREP" prot.pdb)
  if [[ ${#N318_CG1} ]]; then
    nX1=$(echo $N318_CG1 | awk '{print $7}')
    nY1=$(echo $N318_CG1 | awk '{print $8}')
    nZ1=$(echo $N318_CG1 | awk '{print $9}')
    echo "N318_CG1 coords: "$nX1" "$nY1" "$nZ1
  else
    echo "N318_CG1 coords: not found. Exiting..."
    exit 0
  fi

    chn2=$2
    if [[ ${#chn2} -gt 1 ]]; then
      echo $USAGE" Exiting..."
      exit 0
    fi
    # Retrieve E148 coordinates for 2nd chain:
    strGREP=""; strGREP=" 'CB  GLU "$chn2" 148 ' "
    E1_CB2=$(eval grep "$strGREP" prot.pdb)
    if [[ ${#E1_CB2} ]]; then
      e1X2=$(echo $E1_CB2 | awk '{print $7}')
      e1Y2=$(echo $E1_CB2 | awk '{print $8}')
      e1Z2=$(echo $E1_CB2 | awk '{print $9}')
      echo "E1_CB2 coords: "$e1X2" "$e1Y2" "$e1Z2
    else
      echo "E1_CB2 coords: not found. Exiting..."
      exit 0
    fi
    # Retrieve E203 coordinates for 2nd chain:
    strGREP=""; strGREP=" 'CB  GLU "$chn2" 203 ' "
    E2_CB2=$(eval grep "$strGREP" prot.pdb)
    if [[ ${#E2_CB2} ]]; then
      e2X2=$(echo $E2_CB2 | awk '{print $7}')
      e2Y2=$(echo $E2_CB2 | awk '{print $8}')
      e2Z2=$(echo $E2_CB2 | awk '{print $9}')
      echo "E2_CB2 coords: "$e2X2" "$e2Y2" "$e2Z2
    else
      echo "E2_CB2 coords: not found. Exiting..."
      exit 0
    fi
    # Retrieve N318 coordinates
    strGREP=""; strGREP=" 'CG  ASN "$chn2" 318 ' "
    N318_CG2=$(eval grep "$strGREP" prot.pdb)
    if [[ ${#N318_CG2} ]]; then
      nX2=$(echo $N318_CG2 | awk '{print $7}')
      nY2=$(echo $N318_CG2 | awk '{print $8}')
      nZ2=$(echo $N318_CG2 | awk '{print $9}')
      echo "N318_CG2 coords: "$nX2" "$nY2" "$nZ2
    else
      echo "N318_CG2 coords: not found. Exiting..."
      exit 0
    fi

S2="step2_out.pdb"
# Save MEM atoms:
if [[ -f step2_out.pdb.bkp ]]; then
  S2="step2_out.pdb.bkp"
fi
if [[ $(grep -v MEM $S2 |wc -l) -eq 0 ]];then
  echo "No membrane in step2 of " $dir
  exit 0
fi
grep -v MEM $S2 > S2-noMEM.pdb
grep MEM $S2 > MEM.pdb

if [[ "$S2" == "step2_out.pdb" ]]; then
  mv $S2 step2_out.pdb.bkp
fi

#ATOM  51457 0C00 MEM M0001_000 -31.464 -39.982 -15.919   1.700       0.000      BK________
#1     2     3    4   5         6       7       8         9           10         11
#"%-6s%5d %-4s   %3s %9s        %8.3f   %8.3f   %8.3f     %8.3f       %8.3f     %-12s\n"

 awk -v e1x1="$e1X1" -v e1y1="$e1Y1" -v e1x2="$e1X2" -v e1y2="$e1Y2" -v lim1="$cutoff1" \
     -v e2x1="$e2X1" -v e2y1="$e2Y1" -v e2z1="$e2Z1" -v e2x2="$e2X2" -v e2y2="$e2Y2" -v e2z2="$e2Z2" -v lim2="$cutoff2" \
     -v Nx1="$nX1" -v Ny1="$nY1" -v Nx2="$nX2" -v Ny2="$nY2" -v lim3="$cutoff3" \
     ' BEGIN{ S2_mem_format="%-6s%5d %-4s %3s %9s %8.3f%8.3f%8.3f%8.3f    %8.3f %-12s\n" } \
     { diste1c1=sqrt((e1x1-$6)^2 + (e1y1-$7)^2); diste2c1=sqrt((e1x2-$6)^2 + (e1y2-$7)^2); \
       diste1c2=sqrt((e1x2-$6)^2 + (e1y2-$7)^2); diste2c2=sqrt((e2x2-$6)^2 + (e2y2-$7)^2); \
       distNc1=sqrt((Nx1-$6)^2 + (Ny1-$7)^2); distNc2=sqrt((Nx2-$6)^2 + (Ny2-$7)^2);
       { if ( (diste1c1 <= lim1) || (diste1c2 <= lim1) || \
             ((diste2c1 <= lim2)&&($8 >= e2z1)) || ((diste2c2 <= lim2)&&($8 >= e2z1)) || \
              (distNc1 <= lim3) || (distNc2 <= lim3) ) {$4="REM"} }; \
           printf(S2_mem_format,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) }' MEM.pdb  > MEM.pdb.new

rem=$(grep 'REM' MEM.pdb.new | wc -l)
if [[ $rem -eq 0 ]]; then
  echo "No embedded MEM atm found in " $dir
else
#  grep 'REM' MEM.pdb.new > MEMrem.pdb   # save atms flagged for removal
  sed -i '/REM/d' MEM.pdb.new
fi
cat S2-noMEM.pdb MEM.pdb.new > S2-MEM-new.pdb
 /bin/rm MEM.pdb MEM.pdb.new* S2-noMEM.pdb

# relink
if [[ -f step2_out.pdb ]]; then
  /bin/rm step2_out.pdb
fi
ln -s S2-MEM-new.pdb step2_out.pdb
egrep 'MEM|_000|_001' S2-MEM-new.pdb > s2-small.pdb; mcce2pdb.sh s2-small.pdb; /bin/rm s2-small.pdb
