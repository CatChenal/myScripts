#!/bin/bash
# Cat Chenal @ Gunner lab - 2011-06-22

 for fldr in `echo cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111`
 do
   cd $fldr
   echo "OK: $fldr"
   split-res-confs.sh 0148 4.5
   cd ../
 done
 echo "Done"
