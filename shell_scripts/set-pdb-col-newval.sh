#!/bin/bash
# Script: set-pdb-col-newval.sh
# Usage: To reset the value of a pdb column in each line to the one given as argument
#    set-pdb-col-newval.sh pdb pdb_col new_val
#
# xr Format of pdb file: 12 or 11 fields:
# ATOM     42  N   ASP A   3     -3.438  10.292  19.269  1.00 19.47           N
#              ^   ^   ^   ^                            ^
# 1        2   3   4   5   6  7        8       9        10    11              12
# xr Format of pdb file: 11 fields
# ATOM     42  N   ASP A9999    -3.438  10.292  19.269  1.00 19.47           N
#              ^   ^   ^      ^                             ^
# 1        2   3   4   5      6       7       8        9     10              11
# mcce Format of step2 file:
# ATOM      1  N   ARG A0017_000  78.380  43.780  77.170   1.500      -0.350      BK____M000
#              ^   ^   ^          ^                        ^          ^
# 1        2   3   4   5          6       7       8       9           10          11
# namd Format: 11, 12 or 13 fields:
# ATOM   2012  CE  HIS P 301      -3.211   6.237 -12.487  1.00  0.00      O1  C
# 1        2   3   4   5 6        7        8     9        10    11        12  13
# ATOM   2012  CE  HIS P1301      -3.211   6.237 -12.487  1.00  0.00      O1  C
# 1        2   3   4   5          6        7     8        9     10        11  12
# ATOM   2012  FE  HEMEP 301      -3.211   6.237 -12.487  1.00  0.00      O1  FE
# 1        2   3   4     5        6        7     8        9     10        11  12
# ATOM   2012  FE  HEMEP1301      -3.211   6.237 -12.487  1.00  0.00      O1  FE
# 1        2   3   4              5        6     7        8     9         10  11
# ATOM   2034  HA  HEMEO 301      -2.772   5.414 -16.254  1.00  0.00      O1
# 1        2   3   4     5        6     7       8        9     10         11

if [[ $# -lt 4 ]]; then
  this=$(basename $0)
  echo $this":: requires 5 arguments. Call: "
  echo "> "$this" in_pdb pdb_col new_val out_pdb format[xr, mcce, namd]"
  exit 0
fi
frmt=
case $5 in
    xr | XR )      frmt=0
    ;;
    mcce | MCCE )  frmt=1
    ;;
    namd | NAMD )  frmt=2
    ;;
esac
##echo "$@"

F1=$1
col=$2
new=$3
outfile=$4

##echo "PDBformat: [0=xr; 1=mcce; 2=namd] "$frmt
if [[ "$frmt" -eq 0 ]]; then

  nawk -v newval="$new" -v Col="$col" '
       BEGIN{ prt12="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f%12s\n" } 
      { if ( NF==11 ) { chn=substr($5,1,1); seq=substr($5,2,4) } else { chn=$5; seq=$6 }; 
        if ( Col==5 ) { seq=col } else { $(Col)=newval } 
        {printf(prt12,$1,$2,$3,$4,chn,seq,$7,$8,$9,$10,$11,$12)}; 
      }' $F1 > $outfile

elif [[ "$frmt" -eq 1 ]]; then

  nawk -v newval="$new" -v Col="$col" '
       BEGIN{ prtS2="%-6s%5d %4s %3s %9s%8.3f%8.3f%8.3f %7.3f      %6.3f      %-11s\n" } 
      { $(Col)=newval; {printf(prtS2,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)} }' $F1 > $outfile

elif [[ "$frmt" -eq 2 ]]; then
# ATOM   2034  HA  HEMEO 301      -2.772   5.414 -16.254  1.00  0.00      O1: NF=11:: H atom

  nawk -v newval="$new" -v Col="$col" '
       BEGIN{ prtNAMD="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f      %4s%4s\n" } 
       { if ( NF==11 ) { if ( length($5)==3 ) { res=substr($4,1,4); chn=substr($4,5,1); seq=$5 } 
                                         else { res=substr($4,1,4); chn=substr($4,5,1); seq=substr($4,6,4) } } 
                  else { if ( NF==13 ) { res=$4; chn=$5; seq=$6 } 
                                  else { if ( length($4)==3 ) { res=$4; chn=substr($5,1,1); seq=substr($5,2,4) } 
                                                         else { res=substr($4,1,4); chn=substr($4,5,1); seq=$5 } } };
       { if ( Col==4 ) { res=newval } 
                  else { if ( Col==5 ) { chn=newval } 
                                  else { if ( Col==6 ) { seq=newval } 
                                                  else { $(Col)=newval } } }; 
       { printf(prtNAMD,$1,$2,$3,res,chn,seq,$7,$8,$9,$10,$11,$12,$13) } } }' $F1 > $outfile

fi
