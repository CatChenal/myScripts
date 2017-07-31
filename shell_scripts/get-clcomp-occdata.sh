#!/bin/sh

mypath=`pwd`
if [ $mypath ~= "bin" ];
then
  echo `basename $0` " must be run in a workdir";
  exit 1;
fi

# To be called from parent folder.
# Now: most occ data

for fld in `echo "cl0 cl1 cl2 cl3"`
do

   cd $fld
   if [ -f step2_out.pdb ]; then next;
   else
      ln -s ../step2_out.pdb step2_out.pdb
   fi
   mostocc.py 6 > $fld-mostocc-ph4
   grep -v BK $fld-mostocc-ph4 | awk '{print $4"\t"$5}'|uniq> $fld-occph4.conf

   mostocc.py 7 > $fld-mostocc-ph5
   grep -v BK $fld-mostocc-ph5 | awk '{print $4"\t"$5}'|uniq> $fld-occph5.conf

   mostocc.py 8 > $fld-mostocc-ph6
   grep -v BK $fld-mostocc-ph6 | awk '{print $4"\t"$5}'|uniq> $fld-occph6.conf

   sdiff $fld-occph4.conf $fld-occph6.conf | awk '$2 !~"A|W" {print}' > temp
   echo "Diff btw confs:";echo "pH4                                                             pH6";cat temp > $fld-ph4-6occ.diff

   sdiff $fld-occph5.conf $fld-occph6.conf | awk '$2 !~"A|W" {print}' > temp
   echo "Diff btw confs:";echo "pH5                                                             pH6";cat temp > $fld-ph5-6occ.diff

   sdiff $fld-occph4.conf $fld-occph5.conf | awk '$2 !~"A|W" {print}' > temp
   echo "Diff btw confs:";echo "pH4                                                             pH5";cat temp > $fld-ph4-5occ.diff

   cat *.diff > $fld-occ4-6.alldiff

   /bin/rm temp

cd ..
done

cat cl*/*.alldiff > cl-runs.occ.alldiff

exit 0
