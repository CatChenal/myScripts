#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "....> Missing residue sequence number"
  exit 0
fi
debug=0

resid=$(echo $1|awk '{printf("%04d", $1)}')
#echo $resid
/bin/rm -f epol_range.csv   # epol_range has h3 epol values
touch epol_range.csv

  RESa="A"$resid; RESb="B"$resid  #; echo $RESa $RESb

  # Get neg conf with
  #  - lowest epol:
  nawk -v res="$RESa" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n|head -1 >> epol_range.csv
  nawk -v res="$RESb" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n|head -1 >> epol_range.csv

  lo_negA=$(nawk -v res="$RESa" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'NR==1 {print substr($1,6,15)}')
  lo_negB=$(nawk -v res="$RESb" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'NR==1 {print substr($1,6,15)}')
  #  - highest epol:
  nawk -v res="$RESa" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n|tail -1 >> epol_range.csv
  nawk -v res="$RESb" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n|tail -1 >> epol_range.csv

  hi_negA=$(nawk -v res="$RESa" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'END{print substr($1,6,15)}')
  hi_negB=$(nawk -v res="$RESb" '$2 ~ -1res {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'END{print substr($1,6,15)}')

  # Get neutral conf with
  #  - lowest epol:
  nawk -v res="$RESa" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n|head -1 >> epol_range.csv
  nawk -v res="$RESb" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n|head -1 >> epol_range.csv

  lo_neuA=$(nawk -v res="$RESa" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'NR==1 {print substr($1,6,15)}')
  lo_neuB=$(nawk -v res="$RESb" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'NR==1 {print substr($1,6,15)}')
  #  - highest epol:
  nawk -v res="$RESa" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n|tail -1 >> epol_range.csv
  nawk -v res="$RESb" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n|tail -1 >> epol_range.csv

  hi_neuA=$(nawk -v res="$RESa" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'END{print substr($1,6,15)}')
  hi_neuB=$(nawk -v res="$RESb" '($2 ~ "01"res)||($2 ~ "02"res) {print $2, $(NF-3)}' head3.lst|sort -k2n| awk 'END{print substr($1,6,15)}')
#  echo $lo_negA $lo_negB $hi_negA $hi_negB;  echo $lo_neuA $lo_neuB $hi_neuA $hi_neuB

if [[ $debug -eq 0 ]]; then
  # Get  lowests' xyz:
  grepARG='$lo_negA'
  eval grep "$grepARG" step2_out.pdb > lo_negA_s2.pdb
  grepARG='$lo_negB'
  eval grep "$grepARG" step2_out.pdb > lo_negB_s2.pdb
  grepARG='$lo_neuA'
  eval grep "$grepARG"  step2_out.pdb > lo_neuA_s2.pdb
  grepARG='$lo_neuB'
  eval grep "$grepARG" step2_out.pdb > lo_neuB_s2.pdb

  # Get  highests' xyz:
  grepARG='$hi_negA'
  eval grep "$grepARG" step2_out.pdb > hi_negA_s2.pdb
  grepARG='$hi_negB'
  eval grep "$grepARG" step2_out.pdb > hi_negB_s2.pdb
  grepARG='$hi_neuA'
  eval grep "$grepARG" step2_out.pdb > hi_neuA_s2.pdb
  grepARG='$hi_neuB'
  eval grep "$grepARG" step2_out.pdb > hi_neuB_s2.pdb

  egrep 'CL|_000|_001' step2_out.pdb > s2-small.pdb

# Insert RESx_nnn and remove _001:
# Lo_neg:
  out="lo_neg_"$resid".pdb"
  sedARG=" '/O   GLU "$RESa"_000/r lo_negA_s2.pdb'"
  eval sed "$sedARG" s2-small.pdb > tmp
  sedARG=" '/O   GLU "$RESb"_000/r lo_negB_s2.pdb'"
  eval sed -i "$sedARG" tmp
  sedARG=" '/"$resid"_001/d'"
  eval sed "$sedARG" tmp > $out
  mcce2pdb-strip.sh $out
# /bin/rm $out
# Hi_neg:
  out="hi_neg_"$resid".pdb"
  sedARG=" '/O   GLU "$RESa"_000/r hi_negA_s2.pdb'"
  eval sed "$sedARG" s2-small.pdb > tmp
  sedARG=" '/O   GLU "$RESb"_000/r hi_negB_s2.pdb'"
  eval sed -i "$sedARG" tmp
  sedARG=" '/"$resid"_001/d'"
  eval sed "$sedARG" tmp > $out
  mcce2pdb-strip.sh $out
# /bin/rm $out
# Lo_neu:
  out="lo_neu_"$resid".pdb"
  sedARG=" '/O   GLU "$RESa"_000/r lo_neuA_s2.pdb'"
  eval sed "$sedARG" s2-small.pdb > tmp
  sedARG=" '/O   GLU "$RESb"_000/r lo_neuB_s2.pdb'"
  eval sed -i "$sedARG" tmp
  sedARG=" '/"$resid"_001/d'"
  eval sed "$sedARG" tmp > $out
  mcce2pdb-strip.sh $out
# /bin/rm $out
# Hi_neu:
  out="hi_neu_"$resid".pdb"
  sedARG=" '/O   GLU "$RESa"_000/r hi_neuA_s2.pdb'"
  eval sed "$sedARG" s2-small.pdb > tmp
  sedARG=" '/O   GLU "$RESb"_000/r hi_neuB_s2.pdb'"
  eval sed -i "$sedARG" tmp
  sedARG=" '/"$resid"_001/d'"
  eval sed "$sedARG" tmp > $out
  mcce2pdb-strip.sh $out
# /bin/rm $out

/bin/rm lo_negA* lo_negB* lo_neuA* lo_neuB* hi_negA* hi_negB* hi_neuA* hi_neuB* 
#s2-small.pdb

fi
