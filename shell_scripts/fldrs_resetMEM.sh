#!/bin/bash
# To reset all subfolders with corrected membrane using
# parent's mem_pos and mem.pdb (MEM atoms only) files residing
# one level up

for fldr in $(ls -l|awk '/^d/{print $NF}'|grep -v param)
do
   if [[ ! -f mem_pos ]]; then
      echo "Parent corrected membrane position file (mem_pos) not found."
      exit 0
   fi
   if [[ ! -f mem.pdb ]]; then
      echo "Parent corrected membrane file (mem.pdb) not found."
      exit 0
   fi
   cd $fldr

   /bin/rm -f mem_pos
   ln -s ../mem_pos .
   sed -i '/MEM/d' step2_out.pdb
   sed -i '$r ../mem.pdb' step2_out.pdb

   cd ../
done

echo "Done. Ready for S3"
