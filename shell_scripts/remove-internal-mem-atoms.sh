#!/bin/bash
# To remove C-atoms from M chain (MEM res) that are erroneously placed in protein
# cavities by ipece add_membrane routine.
# To be called in folder where prot.pdb and step2_out.pdb reside.
#.........................................................................
# Dist cutoff from chosen anchor [hard coded as 'GLU A\B 148' for the moment] determined from intial
# visualization of internal mem atoms in pymol, of 1OTS dimer membrane.

USAGE=$(basename $0)": 1st_chain_ltr [2nd_chain_ltr]"\n"Single character chain letter."
here=$(pwd)
dir=$(basename $here)
if [[ $# -eq 0 ]]; then
  echo "Up to 2 chain letters expected. None given. Exiting..."
  exit 0
elif [[ $# -gt 2 ]]; then
  echo "Implemented for at most 2 chains. Exiting..."
  exit 0
fi
S2="step2_out.pdb"
if [[ -f step2_out.pdb.bkp ]]; then
  S2="step2_out.pdb.bkp"
fi
if [[ $(grep -v MEM $S2 |wc -l) -eq 0 ]];then
  echo "No membrane in "$S2" of " $dir
  exit 0
fi
#...................................................................................................
 cutoff1=18 # for E148
 cutoff2=12 # for E203
 cutoff3=16 # for N318
 cutoff4=12 # for F190 in monomers only
 cutoff5=20.25 # for L413CD1 in dimers (~ top center of dimer)
echo "Cutoffs (angstroms):   E148: "$cutoff1"; E203: "$cutoff2"; N318: "$cutoff3"; F190 (monomer): "$cutoff4"; L413CD1: "$cutoff5
#.......................................
if [[ $# -le 2 ]]; then
  chn1=$1
  if [[ ${#chn1} -gt 1 ]]; then
    echo $USAGE" Exiting..."
    exit 0
  fi
  strGREP=""; strGREP=" 'CB  GLU "$chn1"0148_001 ' "
  E1_CB1=$(eval grep "$strGREP" $S2)
  if [[ ${#E1_CB1} ]]; then
    e1X1=$(echo $E1_CB1 | awk '{print $6}')
    e1Y1=$(echo $E1_CB1 | awk '{print $7}')
    e1Z1=$(echo $E1_CB1 | awk '{print $8}')
#    echo "E1_CB1 coords: "$e1X1","$e1Y1","$e1Z1
  else
    echo "E1_CB1 coords: not found. Exiting..."
    exit 0
  fi
  # Retrieve E203 coordinates for that chain:
  strGREP=""; strGREP=" 'CB  GLU "$chn1"0203_001 ' "
  E2_CB1=$(eval grep "$strGREP" $S2)
  if [[ ${#E2_CB1} ]]; then
    e2X1=$(echo $E2_CB1 | awk '{print $6}')
    e2Y1=$(echo $E2_CB1 | awk '{print $7}')
    e2Z1=$(echo $E2_CB1 | awk '{print $8}')
#    echo "E2_CB1 coords: "$e2X1","$e2Y1","$e2Z1
  else
    echo "E2_CB1 coords: not found. Exiting..."
    exit 0
  fi
  # Retrieve N318 coordinates
  strGREP=""; strGREP=" 'CG  ASN "$chn1"0318_001 ' "
  N318_CG1=$(eval grep "$strGREP" $S2)
  if [[ ${#N318_CG1} ]]; then
    nX1=$(echo $N318_CG1 | awk '{print $6}')
    nY1=$(echo $N318_CG1 | awk '{print $7}')
    nZ1=$(echo $N318_CG1 | awk '{print $8}')
#    echo "N318_CG1 coords: "$nX1","$nY1","$nZ1
  else
    echo "N318_CG1 coords: not found. Exiting..."
    exit 0
  fi
  # Retrieve F190 coordinates (for monomer only):
  strGREP=""; strGREP=" 'CB  PHE "$chn1"0190_001 ' "
  F190_CB1=$(eval grep "$strGREP" $S2)
  if [[ ${#F190_CB1} ]]; then
    fX1=$(echo $F190_CB1 | awk '{print $6}')
    fY1=$(echo $F190_CB1 | awk '{print $7}')
    fZ1=$(echo $F190_CB1 | awk '{print $8}')
#    echo "F190_CB1 coords: "$fX1","$fY1","$fZ1
  else
    echo "F190_CB1 coords: not found. Exiting..."
    exit 0
  fi
  # Retrieve L413CD1 coordinates (for dimer):
  strGREP=""; strGREP=" 'CD1 LEU "$chn1"0413_001 ' "
  L413_CD1=$(eval grep "$strGREP" $S2)
  if [[ ${#L413_CD1} ]]; then
    lX1=$(echo $L413_CD1 | awk '{print $6}')
    lY1=$(echo $L413_CD1 | awk '{print $7}')
    lZ1=$(echo $L413_CD1 | awk '{print $8}')
#    echo "L413_CD1 coords: "$lX1","$lY1","$lZ1
  else
    echo "L413_CD1 coords: not found. Exiting..."
    exit 0
  fi
  if [[ $# -eq 2 ]]; then

    chn2=$2
    if [[ ${#chn2} -gt 1 ]]; then
      echo $USAGE" Exiting..."
      exit 0
    fi
    # Retrieve E148 coordinates for 2nd chain:
    strGREP=""; strGREP=" 'CB  GLU "$chn2"0148_001 ' "
    E1_CB2=$(eval grep "$strGREP" $S2)
    if [[ ${#E1_CB2} ]]; then
      e1X2=$(echo $E1_CB2 | awk '{print $6}')
      e1Y2=$(echo $E1_CB2 | awk '{print $7}')
      e1Z2=$(echo $E1_CB2 | awk '{print $8}')
 #     echo "E1_CB2 coords: "$e1X2" "$e1Y2" "$e1Z2
    else
      echo "E1_CB2 coords: not found. Exiting..."
      exit 0
    fi
    # Retrieve E203 coordinates for 2nd chain:
    strGREP=""; strGREP=" 'CB  GLU "$chn2"0203_001 ' "
    E2_CB2=$(eval grep "$strGREP" $S2)
    if [[ ${#E2_CB2} ]]; then
      e2X2=$(echo $E2_CB2 | awk '{print $6}')
      e2Y2=$(echo $E2_CB2 | awk '{print $7}')
      e2Z2=$(echo $E2_CB2 | awk '{print $8}')
  #    echo "E2_CB2 coords: "$e2X2" "$e2Y2" "$e2Z2
    else
      echo "E2_CB2 coords: not found. Exiting..."
      exit 0
    fi
    # Retrieve N318 coordinates
    strGREP=""; strGREP=" 'CG  ASN "$chn2"0318_001 ' "
    N318_CG2=$(eval grep "$strGREP" $S2)
    if [[ ${#N318_CG2} ]]; then
      nX2=$(echo $N318_CG2 | awk '{print $6}')
      nY2=$(echo $N318_CG2 | awk '{print $7}')
      nZ2=$(echo $N318_CG2 | awk '{print $8}')
   #   echo "N318_CG2 coords: "$nX2" "$nY2" "$nZ2
    else
      echo "N318_CG2 coords: not found. Exiting..."
      exit 0
    fi
    # Retrieve L413CD1 coordinates (for dimer):
    strGREP=""; strGREP=" 'CD1 LEU "$chn2"0413_001 ' "
    L413_CD2=$(eval grep "$strGREP" $S2)
    if [[ ${#L413_CD2} ]]; then
      lX2=$(echo $L413_CD2 | awk '{print $6}')
      lY2=$(echo $L413_CD2 | awk '{print $7}')
      lZ2=$(echo $L413_CD2 | awk '{print $8}')
    #  echo "L413_CD2 coords: "$lX2","$lY2","$lZ2
    else
      echo "L413_CD2 coords: not found. Exiting..."
    exit 0
  fi
 fi
fi

# Save MEM atoms:
grep -v MEM $S2 > S2-noMEM.pdb
grep MEM $S2 > MEM.pdb

if [[ "$S2" == "step2_out.pdb" ]]; then
  mv $S2 step2_out.pdb.bkp
fi

#ATOM  51457 0C00 MEM M0001_000 -31.464 -39.982 -15.919   1.700       0.000      BK________
#1     2     3    4   5         6       7       8         9           10         11
#"%-6s%5d %-4s   %3s %9s        %8.3f   %8.3f   %8.3f     %8.3f       %8.3f%16s\n"
S2fmt="%-6s%5d %-4s %3s %9s%8.3f%8.3f%8.3f%8.3f    %8.3f%16s\n"

if [[ $# -eq 2 ]]; then	# 2 chains:
nawk -v e1x1="$e1X1" -v e1y1="$e1Y1" -v e1z1="$e1Z1" -v e1x2="$e1X2" -v e1y2="$e1Y2" -v e1z2="$e1Z2" -v lim1="$cutoff1" \
     -v e2x1="$e2X1" -v e2y1="$e2Y1" -v e2z1="$e2Z1" -v e2x2="$e2X2" -v e2y2="$e2Y2" -v e2z2="$e2Z2" -v lim2="$cutoff2" \
     -v Nx1="$nX1" -v Ny1="$nY1" -v Nz1="$nZ1" -v Nx2="$nX2" -v Ny2="$nY2" -v Nz2="$nZ2" -v lim3="$cutoff3" \
     -v Lx1="$lX1" -v Ly1="$lY1" -v Lz1="$lZ1" -v Lx2="$lX2" -v Ly2="$lY2" -v Lz2="$lZ2" -v lim5="$cutoff5" \
     -v S2_format="$S2fmt" \
     '{ diste1c1=sqrt((e1x1-$6)^2 + (e1y1-$7)^2 + (e1z1-$8)^2); \
        diste2c1=sqrt((e2x1-$6)^2 + (e2y1-$7)^2 + (e2z1-$8)^2); \
        diste1c2=sqrt((e1x2-$6)^2 + (e1y2-$7)^2 + (e1z2-$8)^2); \
        diste2c2=sqrt((e2x2-$6)^2 + (e2y2-$7)^2 + (e2z2-$8)^2); \
        distNc1=sqrt((Nx1-$6)^2 + (Ny1-$7)^2 + (Nz1-$8)^2); distNc2=sqrt((Nx2-$6)^2 + (Ny2-$7)^2 + (Nz2-$8)^2); \
        distLc1=sqrt((Lx1-$6)^2 + (Ly1-$7)^2 + (Lz1-$8)^2); distLc2=sqrt((Lx2-$6)^2 + (Ly2-$7)^2 + (Lz2-$8)^2); \
        { if ( (diste1c1 <= lim1) || (diste1c2 <= lim1) || \
               (diste2c1 <= lim2) || (diste2c2 <= lim2) || \
                (distNc1 <= lim3) || (distNc2 <= lim3) || \
                (distLc1 <= lim5) || (distLc2 <= lim5) ) {$4="REM"} }; \
        printf(S2_format,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) }' MEM.pdb  > MEM.pdb.new

else
# membrane on a monomer:
 nawk -v e1x="$e1X1" -v e1y="$e1Y1" -v e1z="$e1Z1" -v lim1="$cutoff1" \
      -v e2x="$e2X1" -v e2y="$e2Y1" -v e2z="$e2Z1" -v lim2="$cutoff2" \
      -v Nx="$nX1" -v Ny="$nY1" -v Nz="$nZ1" -v lim3="$cutoff3" \
      -v Fx="$fX1" -v Fy="$fY1" -v Fz="$fZ1" -v lim4="$cutoff4" \
      -v S2_format="$S2fmt" \
      '{ diste1=sqrt((e1x-$6)^2 + (e1y-$7)^2 + (e1z-$8)^2); diste2=sqrt((e2x-$6)^2 + (e2y-$7)^2 + (e2z-$8)^2); \
         distN=sqrt((Nx-$6)^2 + (Ny-$7)^2 + (Nz-$8)^2); distF=sqrt((Fx-$6)^2 + (Fy-$7)^2 + (Fz-$8)^2); \
         { if ( (diste1 <= lim1) || (diste2 <= lim2) || (distN <= lim3) || (distF <= lim4) ) {$4="REM"} }; \
         printf(S2_format,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) }' MEM.pdb  > MEM.pdb.new
fi

rem=$(grep 'REM' MEM.pdb.new | wc -l)
if [[ $rem -eq 0 ]]; then
  echo "No embedded MEM atm found in " $dir
else
#  grep 'REM' MEM.pdb.new > MEM-removed.pdb   # save atms flagged for removal
  sed -i '/REM/d' MEM.pdb.new
fi
cat S2-noMEM.pdb MEM.pdb.new > S2-MEM-new.pdb
/bin/rm MEM.pdb MEM.pdb.new* S2-noMEM.pdb

# relink
if [[ -f step2_out.pdb ]]; then
  /bin/rm step2_out.pdb
fi
ln -s S2-MEM-new.pdb step2_out.pdb
egrep 'MEM|_000|_001' step2_out.pdb > s2-small.pdb; mcce2pdb.sh s2-small.pdb; /bin/rm s2-small.pdb
