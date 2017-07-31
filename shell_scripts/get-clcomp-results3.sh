#!/bin/bash

if [ `pwd`| `grep bin` ];
then
  echo `basename $0` " must be run in a workdir";
  exit 1;
fi

# To be called from parent folder.
# For each subfldr:

fldr="cl"

for (( i=0; i<=3; i++ )); 
do

   cd $fldr$i;
   get-egrepline-from-list.sh ../rois.id fort.38.non0 rois.fort.38.non0
   cat rois.fort.38.non0 | awk '{print $1}' > rois.non0.conf

   # Get each conf mfe++ as per subfolder conditions:
   get-mfe+-for-conf.sh rois.non0.conf

   cd ..
done

# Use simple format rois list to collate data from pK.out and sum_crg.out:

get-egrepline-from-list.sh rois.id 'cl*/pK.out' cl-runs-rois.pk
sed -i -e 's/:/ /' -e 's/\// /' -e 's/ >14.0/14.001/' -e 's/  <0.0/-0.001/' cl-runs-rois.pk

get-egrepline-from-list.sh rois.id 'cl*/sum_crg.out.non0' temp.sumcrg
sed -i -e 's/105/Sum/' -e 's/:/ /' -e 's/\// /' temp.sumcrg
awk '{if ($3=="pH") $1="cl "; print}' temp.sumcrg |uniq| sed  's/pH/apH       /'| sort -k3 -k1> cl-runs-rois.sum_crg.out.non0
/bin/rm temp.sumcrg


#Get all from sum_crg.out & pK.out:

egrep 'pH|_' cl*/sum_crg.out.non0 | grep -v Net | sed -e 's/105/Sum/' -e 's/:/ /' -e 's/\// /' > temp.1
awk '{if ($3=="pH") $1="cl "; print}' temp.1 | uniq | sed  's/pH/apH       /'| sort -k3 -k1> cl-runs-all.sum_crg.out.non0
/bin/rm temp.1

egrep _ cl*/pK.out > temp.pk
sed -i -e 's/:/ /' -e 's/\// /' -e 's/ >14.0/14.001/' -e 's/  <0.0/-0.001/' temp.pk
sort -k3 -k1 temp.pk > cl-runs-all.pk.out
/bin/rm temp.pk



# Get one single list of rois conformers for use with other files:
cat cl*/rois.non0.conf | sort | uniq > cl-runs-rois.conf

get-egrepline-from-list.sh cl-runs-rois.conf 'cl*/head3.lst.totE' temp.totE
grep totE temp.totE | sed -e 's/:/ /' -e 's/\// /' | sort -k4 -k1 >  cl-runs-rois.h3.totE
/bin/rm temp.totE

get-egrepline-from-list.sh cl-runs-rois.conf 'cl*/fort.38.non0' temp.38
grep : temp.38 | sed -e 's/:/ /' -e 's/\// /' | sort -k3 -k1 >  cl-runs-rois.fort.38.non0
/bin/rm temp.38

#Collate each conf's mfe+ results:
egrep '_' cl*/*.mfe+| sed -e 's/:/ /' -e 's/\// /' -e 's/\.mfe+/ /' | sort -k2 -k3 > cl-runs-rois.mfe+
egrep SUM cl*/*.mfe+ | sed -e 's/\// /' -e 's/\.mf/ .mf/' | sort -k2 -k3 > cl-runs.SUM.mfe+

