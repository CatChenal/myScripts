#!/bin/bash
# TO be called outside a subfolder containing converted (.PDB) files that are preferably most-occ files.
#  To get all ions/ligands as a chain for coloring purposes:
#   -> visualize resulting pdb in pymol & color by spectrum; set sphere_scale to 1.50
#   -> save as pic to overlay on distance graph.
# Note: "-1" in reassignment of x-coord: to match time-slice of struc coming from an md sim (e.g. t-0 -> md_00 -> ion00 -> xyz(0,0,0);
#     (awk increments counter before assignment, so r=1 on the '0th' slice).
#
A1="ARG1 :: ion name (e.g. CL, PO4)"
A2="ARG2 :: separation_distance (separation of 4 btw ion maybe too tight; 8 better)"
A3="ARG3 :: folder containing converted (.PDB) files"
A4="ARG4 :: slice: e.g. start of name of pdbs in given folder"
A5="[ARG5 :: atom_name_selection: atom to select in a multi-ion atom, e.g. 'P   PO4']"
#
if [ $# -lt 4 ]; then
  echo "Argument(s) missing:"
  echo "           "$A1
  echo "           "$A2
  echo "           "$A3
  echo "           "$A4
  echo "           "$A5
  echo "Example: get-ion-spectrum.sh PO4 8 PDBs7 GlpT_PI P"
  exit 0
fi
ION=$1
GAP=$2
FLDR=$3
SLICE=$4
sedARG=" 's/^"$FLDR"\/"$SLICE"//' "
grepARG=" $ION $FLDR/$SLICE*.PDB"
outfile1=$FLDR/$ION.xyz

# Coordinates of most occ'd IONs & Replace res_ID w/slice id: col 7 = col 1
eval egrep "$grepARG" | eval sed "$sedARG" |sed -e 's/-occ7.PDB//' -e 's/:/ /' | \
awk ' { printf("%-6s%5d%4s%5s%2s%4s    %8.3f%8.3f%8.3f\n", $2,$3,$4,$5,$6,$1,$8,$9,$10)}' > $outfile1.PDB

# Bring all ions on one axis with GAP for separation:
if [ $# -eq 5 ]; then
  outfile2=$outfile1.$5-spectrum-gap$GAP.PDB
  awk -v gap=$GAP -v atm="$5" '\
   { for( r=0; r<=NR; r++ ) $7=(-1+r)*gap}; $8=0.000; $9=0.000; $3~atm  \
   { printf("%-6s%5d%4s%5s%2s%4s    %8.3f%8.3f%8.3f\n", $1,$2,$3,$4,$5,$6,$7,$8,$9)}' $outfile1.PDB > $outfile2
else
  outfile2=$outfile1.spectrum-gap$GAP.PDB
  awk -v gap=$GAP '\
   { for( r=0; r<=NR; r++ ) $7=(-1+r)*gap}; $8=0.000; $9=0.000; \
   { printf("%-6s%5d%4s%5s%2s%4s    %8.3f%8.3f%8.3f\n", $1,$2,$3,$4,$5,$6,$7,$8,$9)}' $outfile1.PDB > $outfile2
fi
/bin/rm $FLDR/tmp
