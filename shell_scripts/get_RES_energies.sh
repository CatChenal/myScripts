#/bin/bash

if [ $# -ne 3 ]; then
  echo "ARGS(3): Occupancy-like file to use; occ type (ph/eh/ch); RESID (e.g. 0024)"
  exit 0
fi
#......................................................
OCC_file=$1
occ=$2
RESID=$3

RES_A="A"$RESID
RES_B="B"$RESID

CUTOFF=1
SFX="-occ.csv"

# 1. Get list of most occupied conformers & string of their IDs for grepping:
egrep $RESID $OCC_file > RES_mostocc.csv
grep A0 RES_mostocc.csv > $RES_A"_"$occ$SFX
grep B0 RES_mostocc.csv > $RES_B"_"$occ$SFX

# 2. Get list of all most favorable conf from head3 (may be large):
h3_mostfav.sh $RES_A 1  # output name = $RES_A_mostfav.csv; this file has selected cols for energies calcs
h3_mostfav.sh $RES_B 1  # output name = $RES_B_mostfav.csv;

CUTOFF=1
# 4. Create batch file to get mfe of most occ'd confs:
awk -v cut="$CUTOFF" 'NR>1{ print "mfe++ "$1, cut, cut,">", $1".mfesm.csv" } END{print "/bin/rm *.mfe"}' $RES_A"_mostfav.csv" > cmd_out.A
echo "cmd_out.A: "
cat cmd_out.A

awk -v cut="$CUTOFF" 'NR>1{ print "mfe++ "$1, cut, cut,">", $1".mfesm.csv" } END{print "/bin/rm *.mfe"}' $RES_B"_mostfav.csv" > cmd_out.B
echo "cmd_out.B: "
cat cmd_out.B

do_this=0
if [[ $do_this -eq 1 ]]; then
   # 5. Execute and get reduced-size mfe file:
   read -p "Execute cmd to get RES mfe? (0/1)" run_cmd
   if [ $run_cmd -eq 1 ]; then
     . cmd_out.A
     /bin/rm cmd_out.A
   fi
fi
/bin/rm  RES_mostocc.csv
