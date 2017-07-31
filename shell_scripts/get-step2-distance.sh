#!/bin/bash
# Scriptname: get-step2-distance.sh
# Cat Chenal @ Gunner Lab; 2013-0611-05
# --------------------------------------------------------------------------------------------------------
# get-step2-distance.sh
# Uses any pdb in the format of step2_out.pdb (only ATOM lines).
# The script returns a copy of the input file with an additional column holding the distance between each
# residue's coordinates and those of the anchor if given by residue and atom using the -resi option;
# or the coordinates directly passed as arguments withotu the option.
# Specific purpose: to be able to grep from the resulting file all the conformers within a given distance
# from the anchor provided.  This can be done easily using AWK.
## This command will list atoms within 5A of the chosen anchor (named XYZ466):
## awk '$(NF)<5.00 {print}' dist_XYZ466_step2.pdb
# ----------------------------------------------------------------------------------------------------------

this=$(basename $0)
Usage1=$this"      pdb anchor_name anchor_coordinate_x anchor_coordinate_y anchor_coordinate_z"
Usage2=$this" -res pdb anchor_name chain_ltr seq_num atom_name"
details="Note:  anchor_name must not contain spaces. => \n $this -coord input.pdb 'XYZ466' 14.000 -6.800 40.800"
#Usage2=$Usage2"    last 2: [converted]: 1(yes)=pdb_format, 09n0): step2_format; [verbose]: outputs a log file with .info as extension."

function usage
{
  echo "  Script $this requires a residue (anchor) coordinates as input along with a name for the anchor and the input file name"
  echo "  CALL EXAMPLES: "$Usage1
  echo "                 "$Usage2
  echo "  The output is saved as 'dist_XYZ466_input.pdb"
  echo "  The distance calculation log file is 'dist_XYZ466_input.pdb.info"
  echo " -- $this --  Argument(s) missing."
}

if [ $# -lt 5 ]; then
  usage
  exit
fi

inpdb=
anchor=
resi=0
converted=0
info=0
no_op=0

while [ "$1" != "" ]; do
    case $1 in
        -res | --residue )	resi=1
                                ;;
        -i | --info )   	info=1
                                ;;
        -pdb | --pdb_format )   converted=1
                                ;;
    esac
    shift
done

if [[ $resi -eq 0 ]]&&[[ info -eq 0 ]]&&[[ converted -eq 0 ]]; then
  # no options passed
  no_op=1
fi

  X=$1;  Y=$2;  Z=$3
  anchor=$4
  inpdb=$5
  outpdb="dist_"$anchor"_"$inpdb
  converted=0
  if [[ $# -eq 6 ]]; then
    if [[ $6 -ge 1 ]]; then
      converted=1
    fi
  fi
  MEM=$(eval grep -q 'MEM' $inpdb &> /dev/null)
  if [[ $MEM -eq 0 ]]; then     #found
    grep -v MEM $inpdb >tmp
    inpdb="tmp"
  fi

  # mcce format: xyz in col:                      6,      7,      8
  #              ATOM      1  CL  _CL O0466_001   4.794   5.595   1.773   1.937      -1.000      -1O000M000
  #              ATOM      2  N   ARG P0017_000 -22.061 -15.228  28.007   1.500      -0.350      BK____M000
  # pdb format=converted: xyz in col:            7,     8,      9
  #              ATOM      1  CA  NTR A  17      49.758 -12.116  54.808
#...........................................................................................................
# awk 'BEGIN{prt12="%-6s%5d %-4s %3s %s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s\n"} \
#     { if(NF==12) {printf(prt12,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)} \
#             else {printf(prt12,$1,$2,$3,$4,substr($5,1,1),substr($5,2,4),$6,$7,$8,$9,$10,$11)} }' $1 > tmp
#...........................................................................................................
  if [ "$converted" -eq 1 ]; then
    nawk -v x=$X -v y=$Y -v z=$Z '{sq=sqrt((x-$7)^2 + (y-$8)^2 + (z-$9)^2);
     { printf("%-6s%5d %4s %3s %s%4d    %8.3f\n",$1,$2,$3,$4,$5,$6,sq) }}' $inpdb > $outpdb
  else
    nawk -v x=$X -v y=$Y -v z=$Z '{sq=sqrt((x-$6)^2 + (y-$7)^2 + (z-$8)^2); 
     { printf("%-6s%5d %4s %3s %5s    %8.3f\n",$1,$2,$3,$4,$5,sq) }}' $inpdb > $outpdb

    # full line prt format="%-6s%5d %4s %3s %s%4d    %8.3f%8.3f%8.3f%8.3f%6.2f%6.2f      %-4s [lst:2d?]]\n"
  fi
  if [ "$#" -eq 7 ] && [ "$7" -eq 1 ]; then
    echo "Output file: $outpdb; Last column = distance from $anchor ($X, $Y, $Z). `date`" >> $outpdb.info
    cat $outpdb.info
    echo
    echo "-- $this -- over."
  fi
  if [[ $MEM -eq 0 ]]; then
    /bin/rm $inpdb
  fi
