#/bin/bash

if [ $# -ne 2 ]; then
  echo "ARGS(2): Occupancy-like file to use; occ type (ph/eh/ch)"
  exit 0
fi
#......................................................
CUTOFF=1

# 1. Get list of most occupied conformers & string of their IDs for grepping:
egrep 0148 $1 > E148_mostocc.csv
grep A0 E148_mostocc.csv >"A0148_"$2"-occ.csv"
grep B0 E148_mostocc.csv >"B0148_"$2"-occ.csv"

# 2. Get list of all most favorable conf from head3 (may be large):
h3_mostfav.sh 0148 1  # output :: 0148_mostfav.csv; this file has selected cols for energies calcs

CUTOFF=1
# 4. Create batch file to get mfe of most occ'd confs:
awk -v cut="$CUTOFF" '{ print "mfe++ "$1, cut, cut,">", $1".mfesm.csv" } END{print "/bin/rm *.mfe"}' E148_mostocc.csv > cmd_out
cat cmd_out

# 5. Execute and get reduced-size mfe file:
read -p "Execute get_E148_mfe.cmd? (0/1)" run_cmd
if [ $run_cmd -eq 1 ]; then
  . cmd_out
  /bin/rm cmd_out
fi

 /bin/rm *0148_mostfav.csv E148_mostocc.csv

