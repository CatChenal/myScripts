egrep 'CLDM|U-1.0148' */fort.38.non0 |sed 's/\/fort\.38\.non0:/ /'| egrep 'CL_[0|1|f][0|1|f][0|1|f]* ' > tmp
grep A0 tmp > QER0_A_CLDM_Ex_occ_curve.csv
grep B0 tmp > QER0_B_CLDM_Ex_occ_curve.csv

awk '{print $1, $2, $3}' QER0_A_CL_Ex_occ_curve.csv > QER0_A_CL_Ex_occ_curve_bound.csv
awk '{print $1, $2, $3}' QER0_B_CL_Ex_occ_curve.csv > QER0_B_CL_Ex_occ_curve_bound.csv

# to get sum-mfe over entire titration to get mfe_Kd:
egrep SUM CL_*/_CL*sm_mfe.csv|sed 's/\.sm_mfe\.csv:SUM/ /; s/\// /' > QER0_all_CL-mfesum.csv
awk '/CL_[0|f][0|f][0|f]_ch|CL_000_ch/ {print} ' QER0_all_CL-mfesum.csv | sed 's/\// /' | awk '/A0/ {print}' > QER0_A_CL-mfesum_curve.csv
awk '/CL_[0|f][0|f][0|f]_ch|CL_000_ch/ {print} ' QER0_all_CL-mfesum.csv | sed 's/\// /' | awk '/B0/ {print}' > QER0_B_CL-mfesum_curve.csv

awk 'BEGIN{OFS="\t"}{print $1, $2, $3, $NF}' QER0_A_CL-mfesum_curve.csv > QER0_A_CL-mfesum_curve-sm.csv
awk 'BEGIN{OFS="\t"}{print $1, $2, $3, $NF}' QER0_B_CL-mfesum_curve.csv > QER0_B_CL-mfesum_curve-sm.csv


# to get CL-CL interx over entire titration:
awk '$1 ~/CL/{print substr(FILENAME,1,9),substr(FILENAME,11,14),$0}' CL_*_ch/_CL*sm_mfe.csv| \
egrep 'CL_00f_ch|CL_0f0_ch|CL_f00_ch|CL_0ff_ch|CL_f0f_ch|CL_ff0_ch|CL_fff_ch'|grep A0 > QER0_A_CL-CL_mfe.csv

awk '$1 ~/CL/{print substr(FILENAME,1,9),substr(FILENAME,11,14),$0}' CL_*_ch/_CL*sm_mfe.csv| \
egrep 'CL_00f_ch|CL_0f0_ch|CL_f00_ch|CL_0ff_ch|CL_f0f_ch|CL_ff0_ch|CL_fff_ch'|grep B0 > QER0_B_CL-CL_mfe.csv


# to get sum-mfe in holo and apo points:
awk '$1 ~/CL/{print substr(FILENAME,1,9),substr(FILENAME,11,14),$1, $2, $NF}' CL*_ch/_CL*sm_mfe.csv| \
egrep 'CL_00f_ch|CL_0f0_ch|CL_f00_ch|CL_0ff_ch|CL_f0f_ch|CL_ff0_ch|CL_fff_ch'|grep A0 > QER0_A_CL-CL_mfe-sm.csv

awk '$1 ~/CL/{print substr(FILENAME,1,9),substr(FILENAME,11,14),$1, $2, $NF}' CL*_ch/_CL*sm_mfe.csv| \
egrep 'CL_00f_ch|CL_0f0_ch|CL_f00_ch|CL_0ff_ch|CL_f0f_ch|CL_ff0_ch|CL_fff_ch'|grep B0 > QER0_B_CL-CL_mfe-sm.csv
