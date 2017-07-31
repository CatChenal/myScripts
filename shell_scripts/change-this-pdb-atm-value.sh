#!/bin/bash
# To change a field in a pdb
#Format of new values file: 5 fields
#1   2   3   4   5
#O   ASP A   3   0.66
#Format of new values file (mcce format): 4 fields
#1   2   3        4
#O   ASP Annn_nnn 0.66

#Format of pdb file: 12 fields
#ATOM     42  N   ASP A   3      -3.438  10.292  19.269  1.00 19.47           N
#             ^   ^   ^   ^                            ^
#1        2   3   4   5   6      7       8       9     10    11              12
#Format of pdb file: 11 fields
#ATOM     42  N   ASP A9999    -3.438  10.292  19.269  1.00 19.47           N
#             ^   ^   ^      ^                             ^
#1        2   3   4   5      6       7       8       9     10               11
#Format of step2 file:
#ATOM      1  N   ARG A0017_000  78.380  43.780  77.170   1.500      -0.350      BK____M000
#             ^   ^   ^          ^                        ^          ^
#1        2   3   4   5          6       7       8       9           10                  11

if [[ $# -lt 3 ]]; then
  this=$(basename $0)
  echo $this":: requires three arguments. Call: > "$this" File1[new values] File2[pdb file] pdb_column_for_new_value"
  echo "-----:: Also, both input files must have the same format:"
  echo "-----:: File1 format if pdb file has the standard pdb format:              O   ASP A   3 [new_value];"
  echo "-----:: File1 format if pdb file has the mcce format (i.e. stepx_out.pdb): O   ASP A0017_000 [new_value];"
  exit 0
fi
# Use first file to check if both files have same format:
if [[ "$(awk 'NR==1 {print NF}' $1)" -eq 4 ]]; then		# F1 has S2 format (4 fields)
  F1format=1
else
  F1format=0
fi
F2format=$(nawk 'NR==1 {if ( $5 ~ /_/ ) {print "1"} else {print "0"} }' $2)
if ! [[ "$F1format" -eq "$F2format" ]]; then
  echo "The two input files must have the same format; either standard pdb or mcce format."
  echo "Format mismatch. Exiting..."
  exit 0
fi
F1=$1
F2=$2
new=$3
#echo "PDBformat: [0=standard; 1=mcce] "$F2format
if [[ "$F1format" -eq 0 ]]; then

  while read newinline
  do
    nawk -v newline="$newinline" -v col="$new" '
       BEGIN{ prt12="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"; split(newline,cols) } 
      { 
       if (NF==11) {chn=substr($5,1,1); seq=substr($5,2,4)} else {chn=$5; seq=$6}; 
       if ( ($3==cols[1])&&($4==cols[2])&&(chn==cols[3])&&(seq==cols[4]) ) {$(col)=cols[5]}; 
       {printf(prt12,$1,$2,$3,$4,chn,seq,$7,$8,$9,$10,$11,$12)}; 
      }' $F2
  done < $F1

else

  while read newinline
  do
    nawk -v newline="$newinline" -v col="$new" '
       BEGIN{ prtS2="%-6s%5d %4s %3s %9s%8.3f%8.3f%8.3f %7.3f      %6.3f      %-11s\n"; split(newline,cols) }
      {
       if ( ($3==cols[1])&&($4==cols[2])&&($5==cols[3]) ) {$(col)=cols[4]};
       {printf(prtS2,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)}; 
      }' $F2
  done < $F1

fi
