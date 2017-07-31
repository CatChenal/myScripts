#!/bin/bash
if [[ $# -eq 0 ]]; then
   echo "Required: < pdb_file > < beta_file>"
   exit 0
fi
PDB=$1
echo $PDB
BETA=$2
if [[ ! -f "$BETA" ]]; then
   echo $BETA not found
  exit 0
fi
#0	 1 -  6        Record name   "ATOM  "
#1	 7 - 11        Integer       serial       Atom  serial number.
#<+1 space>
#2	13 - 16        Atom          name         Atom name.
#3	17             Character     altLoc       Alternate location indicator.
#4	18 - 20        Residue name  resName      Residue name.
#<+1 space>
#5	22             Character     chainID      Chain identifier.
#6	23 - 26        Integer       resSeq       Residue sequence number.
#	27             AChar         iCode        Code for insertion of residues.
#<+3 spaces>
#7	31 - 38        Real(8.3)     x            Orthogonal coordinates for X in Angstroms.
#8	39 - 46        Real(8.3)     y            Orthogonal coordinates for Y in Angstroms.
#9	47 - 54        Real(8.3)     z            Orthogonal coordinates for Z in Angstroms.
#10	55 - 60        Real(6.2)     occupancy    Occupancy.
#11	61 - 66        Real(6.2)     tempFactor   Temperature  factor.
#<+10 spaces>
#12	77 - 78        LString(2)    element      Element symbol, right-justified.
#13	79 - 80        LString(2)    charge       Charge  on the atom.
pdb=$(basename $PDB)
out=${BETA:0:3}"_beta_"$pdb
#1         2  3   4   5  6       7      8        9       10  11            12     13
#ATOM      1    N ARGA  17     -21.785 -15.398  28.494  1.00  0.00          N       0.00
#ATOM..    4 .HA..ARG A  17     -20.934 -13.913  27.323  0.00bbbbbb          EEcc
#123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
#                                     1   2   3   4  5  6      7    8    9      10   11 
nawk -v beta="$BETA" 'BEGIN { prtPDB="%-6s%5d %4s%4s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n";
                              while ( getline < beta > 0 ) # load array with contents of file
                              {  n++
                                 bf[n,1] = substr($1, 4, 4)
                                 bf[n,2] = $2
                              }; i=1
                            }
                            { num=sprintf("%04d\n", $6);
                              if (length($3)<4) { atm=sprintf(" %-3s",$3) } else { atm=$3 };
                              if ( num==bf[i,1] ) { b=bf[i,2] }
                              else { i++; b=bf[i,2] };
                              printf ( prtPDB, $1, $2, atm, $4, $5, $6, $7, $8, $9, $10, b)
                            }' $PDB > $out

