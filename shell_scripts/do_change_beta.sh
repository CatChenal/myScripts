#!/bin/bash

read -p "Enter the pdb type:   APO, UP, WT, ASP, DN: " pdb
pdb_type=$( echo ${pdb^^} )

if [[ ! -f "cA_aver_bkb_factors.csv" ]]; then
   echo "The master file holding the betas is not found (cA_aver_bkb_factors.csv)"
   exit 0
fi

# head  cA_aver_bkb_factors.csv
#Res     Ex      Ex      Ex      Ex      CLx     CLx     CLx     CLx     CLc    CLc     CLc     CLc     CLc
#Res     APO     UP      WT      ASP     DN      UP      WT      ASP     DN     UP      WT      ASP     DN
#R_A0017 0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00   0.00    0.00    0.00    0.00
#1       2       3       4       5       6       7       8       9       10     11      12      13      14
# Calls:   change_beta.sh: "Required: < pdb_file > < beta_file>"

if [[ "$pdb_type"=="APO" ]]; then
   PDB="APO_R0/CL_000/APO_0_A.PDB"
   BETA="Ex_APO_bkb_beta.csv"
   awk 'NR>2{print $1, $2}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA
fi

if [[ "$pdb_type"=="UP" ]]; then

   PDB="QE_R0/CL_000/QE_0_A.PDB"
   BETA="Ex_UP_bkb_beta.csv"
   awk 'NR>2{print $1, $3}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="QE_R0/CL_f00/QEf00_6_A.PDB"
   BETA="CLx_UP_bkb_beta.csv"
   awk 'NR>2{print $1, $7}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="QE_R0/CL_0f0/QE0f0_6_A.PDB"
   BETA="CLc_UP_bkb_beta.csv"
   awk 'NR>2{print $1, $11}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA
fi

if [[ "$pdb_type"=="WT" ]]; then

   PDB="WT3CL_R1/CL_000/WT_1_A.PDB"
   BETA="Ex_WT_bkb_beta.csv"
   awk 'NR>2{print $1, $4}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="WT3CL_R1/CL_f00/WT1f00_2_A.PDB"
   BETA="CLx_WT_bkb_beta.csv"
   awk 'NR>2{print $1, $8}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="WT3CL_R1/CL_0f0/WT10f0_2_A.PDB"
   BETA="CLc_WT_bkb_beta.csv"
   awk 'NR>2{print $1, $12}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA
fi
if [[ "$pdb_type"=="ASP" ]]; then

   PDB="WD_R0/CL_000/WD_0_A.PDB"
   BETA="Ex_ASP_bkb_beta.csv"
   awk 'NR>2{print $1, $5}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="WD_R0/CL_f00/WDf00_6_A.PDB"
   BETA="CLx_ASP_bkb_beta.csv"
   awk 'NR>2{print $1, $9}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="WD_R0/CL_0f0/WD0f0_6_A.PDB"
   BETA="CLc_ASP_bkb_beta.csv"
   awk 'NR>2{print $1, $13}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

else

   PDB="DN_R0/CL_000/DN_apo_A.PDB"
   BETA="Ex_DN_bkb_beta.csv"
   awk 'NR>2{print $1, $6}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="DN_R0/CL_f00/DNf004_A.PDB"
   BETA="CLx_DN_bkb_beta.csv"
   awk 'NR>2{print $1, $10}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

   PDB="DN_R0/CL_0f0/DN0f04_A.PDB"
   BETA="CLc_DN_bkb_beta.csv"
   awk 'NR>2{print $1, $14}' cA_aver_bkb_factors.csv > $BETA
   change_beta.sh $PDB $BETA

fi
