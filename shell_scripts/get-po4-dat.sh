#!/bin/bash

  if [ $# -lt 1 ]; then
    echo "Residue of interest: code required"
    exit 0
  fi
# ROI = residue of interest
  ROI=$1

  for fldr  in `inventory-fldrs.sh | grep  S4 | awk '{print $1}'`
  do
    cd $fldr
    # /bin/rm *.full hvrot.pdb entropy.out mc_out
    if [ ! -f "fort.38.non0" ]; then
      getnon0rows.sh fort.38 0.05
    fi
    grep $ROI fort.38|grep -v 0.000 > $ROI.38

    if [ ! -f "respair.lst.non0" ]; then
      getnon0rows.sh respair.lst 1
    fi
    grep $ROI respair.lst.non0 > $ROI.pw
    cd ../
  done

  egrep $ROI GlpT_PI*/$ROI.pw > $ROI.pw.all
# /PO4.38:
  SED_ARG=" 's/\/"$ROI".38:/ /'"
  egrep $ROI GlpT_PI*/$ROI.38 | eval sed "$SED_ARG" > $ROI.38.all
  awk '( ($3 > 0.05) && ($3 < 0.7) ) {print}' $ROI.38.all | awk '{ print $1}'|uniq > $ROI.occ-below-70pct.38.fldr
