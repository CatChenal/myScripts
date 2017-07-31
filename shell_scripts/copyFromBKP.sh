#!/bin/bash

for val in $(cat not-running)
do
# echo "To copy: "$val".pdb"

 cp ChainA_slicesBKP/$val".pdb" ChainA_slices/.

done
