#!/bin/bash
filename="something.pdb"
echo ${filename%.pdb}

for ((x=0; x <= 127; x++)); do
  printf '%03d | %04o | 0x%02x\n' "$x" "$x" "$x"
done
