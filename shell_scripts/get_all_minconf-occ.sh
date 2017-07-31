#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "Required: Data set (folder) identifier"
  exit 0
fi
#here=$(pwd)
#fldr=$(basename $here)
fldr=$1

awk '{print FILENAME, $0}' CL_*/A*_minconfs.csv|sed 's/\// /' > $fldr"_A_minconfs.csv"
awk '{print FILENAME, $0}' CL_*/B*_minconfs.csv|sed 's/\// /' > $fldr"_B_minconfs.csv"

egrep 'ex|ph|A' */*CL-Ex-occ.csv |sed -e 's/\// /; s/\.csv:/ /' > $fldr"_A_CL-Ex-occ.csv"
egrep 'ex|ph|B' */*CL-Ex-occ.csv |sed -e 's/\// /; s/\.csv:/ /' > $fldr"_B_CL-Ex-occ.csv"
