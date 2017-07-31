#!/bin/bash
# To reset current folder membrane with corrected one using
# mem_pos and mem.pdb (MEM atoms only) files residing the 
# parent folder (one level up)

if [[ ! -f ../mem_pos ]]; then
  echo "Corrected membrane position file of parent not found."
  exit 0
fi
if [[ ! -f ../mem.pdb ]]; then
  echo "Corrected membrane atoms file of parent not found."
  exit 0
fi
if [[ ! -f mem_pos ]]; then
  echo "Membrane position file of current run not found. Re-run S2."
  exit 0
fi
/bin/rm -f mem_pos
ln -s ../mem_pos .
sed -i '/MEM/d' step2_out.pdb
sed -i '$r ../mem.pdb' step2_out.pdb
echo "Done. Ready for S3"
