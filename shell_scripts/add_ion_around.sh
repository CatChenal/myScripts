#!/bin/bash
# Creates a pdb file with added ions (around given anchors) for the purpose of adding it back to the parent file;
# (This is why the anchors are not included in the output.)
# Works with a pdb in mcce format;
# As of Nov2013: only works with ions: they need only one identifier and return only one line upon grep if not free floating;
# CL_466: ~ 1.5A apart in WTR0 vs QER0
# -> Add CL every gap value in all directions within grid_len Angs of WTR0 CL466 and within grid_len A of WTR0 CL467
#
USAGE="Required: pdb in mcce format; outfile_name; ion separation [; ions seqids file (eg A0123)]"
if [[ $# -lt 3 ]]; then
  echo $USAGE
  exit 0
fi
mcce_pdb=$1
  CL_out=$2
     gap=$3
if [[ $# -eq 4 ]]; then
 ion_IDs=$4
fi
grid_len=2.0
echo "Grid len: "$grid_len
#If pre-existing file not removed: duplicates
if [[ -f $CL_out ]]; then
  /bin/rm $CL_out
fi

touch $CL_out
DOnext=1

#for ion in $(cat $ion_IDs)
CLxA="A0466"
CLxB="B0466"

for ion in $(echo $CLxA $CLxB)
do
  grep $ion $mcce_pdb |head -1 > ion_pdb  #: a one line pdb corresponding to the native ion if found
  if [[ -s ion_pdb ]]; then
 
    if [[ $DOnext -eq 1 ]]; then
       echo "First ion found:"
       cat ion_pdb
#      seqid=1
##ATOM   9627  CL  _CL A0466_001   4.774   6.344  -1.921   1.937      -1.000      -1O000M000
      nawk -v cl="$ion" -v incr="$gap" -v grid="$grid_len" 'BEGIN{ S2prt="%20s %1s%04d%4s%8.3f%8.3f%8.3f%8.3f      %6.3f      %-10s\n"; 
                  seq=1; ch=substr(cl,1,1); conf=substr(cl,2,4) }
          { xmin=$6-grid; ymin=$7-grid; zmin=$8-grid; xmax=$6+grid; ymax=$7+grid; zmax=$8+grid; 
            for( a=xmin; a<=xmax; a+=incr ) {
                 for( b=ymin; b<=ymax; b+=incr ) {
                      for( c=zmin; c<=zmax; c+=incr ) {
                           seq++
                           seqid=sprintf("_%03d",seq)
                           printf(S2prt,"ATOM  99999  CL  _CL",ch,conf,seqid,a,b,c,$9,$10,$11)
                      }
                 }
             }
           }' ion_pdb >> $CL_out

    fi # DOnext

  else
    echo $ion" not found in "$mcce_pdb
#    exit 0
    continue
  fi

done
/bin/rm ion_pdb
