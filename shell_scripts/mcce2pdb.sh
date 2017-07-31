#!/bin/bash
# Cat Chenal 2011-08-02
# To convert mcce file (eg step2) to pdb format 
# for proper display/selection in pymol

if [ $# -lt 1 ]; then
  echo "Usage:  file_name required [saveas name]."
  exit 0
fi
if [ $# -eq 2 ]; then
  saveas=$2
else
  saveas=$(basename $1 .pdb)".PDB"
fi

MEM=$(eval grep -q 'MEM' $1 &> /dev/null)
if [[ $MEM -eq 0 ]]; then     #found
  grep MEM $1 > mem.tmp
  sed -i '/MEM/d' $1
fi

nawk 'BEGIN{prt12="%-6s%5d %4s %3s %1s%4s    %8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"} \
      { if (length($3)<4){atm=sprintf(" %-3s",$3)} else {atm=$3} } \
      { if($4=="_CL") {$4=" CL"; $11="Cl"} else { if ($4=="CYD") {$4="CYS"}; $11="" } } \
      { printf(prt12,$1,$2,atm,$4,substr($5,1,1),substr($5,2,4),$6,$7,$8,$9,$10,$11) } ' $1 > $saveas

sed -i 's/\( [A|B]\)00/\1  /; s/\( [A|B]\)0/\1 /' $saveas
if [[ $MEM -eq 0 ]]; then
  sed -i '$r mem.tmp' $saveas
fi

/bin/rm $1 *tmp

 echo "Converted pdb was saved as "$saveas
