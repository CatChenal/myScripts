#!/bin/bash
# CL ion processing

if [[ $# -lt 2 ]]; then
  read -p "Enter an identifier for this folder: " fld_id
 read -p "Enter a directory name identifier (for filtering folders): " filter
else
  fld_id=$1
  filter=$2
fi

# Get new subtotal from already prepaired head3 so that
# I can show the main components of dGb:
# dGb(CL-1) = (ddGnpol + ddGepol + ddGdsol )=tot1 + (- dG0(cldm) + res(b-u)[to be added])=tot2 + ioniz
# So that tot1+tot2 will be shown on the binding edges of the cubes, while ionz(Ex)
# will be shown on the vertical egdes.
  # _h3Tot.csv:
  # OUT:  CONFORMER                                         vdw0    vdw1    tors    epol   dsolv   extra    h3Tot
  #       1                                                 2       3       4       5      6       7

awk 'BEGIN{OFS="\t"; print "Run", "CONFORMER", "npol", "epol", "dsolv", "h3Tot"} 
     {if($1 != "CONFORMER") { npol=0; dsol=0; sum=0; npol=$2+$3+$4+$7; dsol=$6; sum=npol+$5+dsol; print FILENAME, $1, npol, $5, dsol, sum }}' CL_fff*/CL_A_h3Tot.csv | \
     sed 's/\/CL_A_h3Tot.csv//'| sed '/CLDM/d' > $fld_id"_A_h3_CLs_tot.csv"

awk 'BEGIN{OFS="\t"; print "Run", "CONFORMER", "npol", "epol", "dsolv", "h3Tot"}
     {if($1 != "CONFORMER") { npol=0; dsol=0; sum=0; npol=$2+$3+$4+$7; dsol=$6; sum=npol+$5+dsol; print FILENAME, $1, npol, $5, dsol, sum }}' CL_fff*/CL_B_h3Tot.csv | \
     sed 's/\/CL_B_h3Tot.csv//'| sed '/CLDM/d' > $fld_id"_B_h3_CLs_tot.csv"

# Res of interest:
# files: *_0148_minconfs.csv
#   hdr: Source  CONFORMER       vdw0    vdw1    tors    epol    dsolv   extra   mfe_b   mfe_u   TOT_b   TOT_u
#        1       2               3       4       5       6       7       8       9       10      11      12
# hdr to match *_CLs_tot.csv:
#        Run     Source   CONFORMER       npol    epol    dsolv   h3Tot  mfe_b   mfe_u   TOT_b   TOT_u

for res in $(echo '0148 0203')
do
   /bin/rm -f *$res"_minconfs.csv"  #prev ver

   fileout=$fld_id"_A_"$res"_minconf-bu.csv"
   awk 'BEGIN{OFS="\t"; print "Run", "Source", "CONFORMER", "npol", "epol", "dsolv", "h3Tot", "mfe_b", "mfe_u", "TOT_b", "TOT_u"}
        { if($2 != "CONFORMER") 
            { idx=index(FILENAME, "/"); 
              sum=0; npol=0; npol=$3+$4+$5+$8; sum=npol+$6+$7;
              print substr(FILENAME, 1, idx-1),$1, $2, npol, $6, $7, sum, $9, $10, $11, $12
            } }' *$filter*/*"A_"$res"_minconfs.csv" > $fileout

   fileout=$fld_id"_B_"$res"_minconf-bu.csv"
   awk 'BEGIN{OFS="\t"; print "Run", "Source", "CONFORMER", "np", "epol", "dsolv", "h3Tot", "mfe_b", "mfe_u", "TOT_b", "TOT_u"}
        { if($2 != "CONFORMER") 
            { idx=index(FILENAME, "/");
              sum=0;npol=0; npol=$3+$4+$5+$8; sum=npol+$6+$7;
              print substr(FILENAME, 1, idx-1),$1, $2, npol, $6, $7,sum, $9, $10, $11, $12
            } }' *$filter*/*"B_"$res"_minconfs.csv" > $fileout
done

/bin/rm *cldm_occ.csv # prev

 awk 'BEGIN{OFS="\t"; sum=1}
     { if ($1 ~ /CLDMA|\-1A0148/)
          { for (i=2;i<NF;i++){sum=sum+$i};
            if ((sum>0)&&(sum<14.90)) { idx=index(FILENAME, "/"); print substr(FILENAME,1, idx-1), $0}}; sum=1 }' *$filter*/fort.38.non0 > $fld_id"_A_Ex_cldm_occ.csv"

 awk 'BEGIN{OFS="\t"; sum=1}
     { if ($1 ~ /CLDMB|\-1B0148/)
          { for (i=2;i<NF;i++){sum=sum+$i};
            if ((sum>0)&&(sum<14.90)) { idx=index(FILENAME, "/"); print substr(FILENAME,1, idx-1), $0}}; sum=1 }' *$filter*/fort.38.non0 > $fld_id"_B_Ex_cldm_occ.csv"

# get occ at first point:
/bin/rm -f *CLx-CLc_occ-b.csv *CLx-CLc_bu.csv 

awk 'BEGIN{OFS="\t"}
     /CL-1A/ { idx=index(FILENAME, "/"); print substr(FILENAME, 1, idx-1),$1,$2 }' *$filter*/fort.38.non0 > $fld_id"_A_CL_occ-b.csv"
awk 'BEGIN{OFS="\t"}
     /CL-1B/ { idx=index(FILENAME, "/"); print substr(FILENAME, 1, idx-1),$1,$2 }' *$filter*/fort.38.non0 > $fld_id"_B_CL_occ-b.csv"

# to get b-u:
awk 'BEGIN{OFS="\t"} 
     /CL-1A0/ {idx=index(FILENAME, "/"); print substr(FILENAME, 1, idx-1),$1,$2,$NF, $2-$NF }' *$filter*/*CL-mfesum.csv > $fld_id"_A_CL_mfe_bu.csv"

awk 'BEGIN{OFS="\t"} 
     /CL-1B0/ {idx=index(FILENAME, "/"); print substr(FILENAME, 1, idx-1),$1,$2,$NF, $2-$NF }' *$filter*/*CL-mfesum.csv > $fld_id"_B_CL_mfe_bu.csv"

