#!/bin/bash

if [[ ! -d pbe_delphi_* ]]; then
   fldr=""
else
   fldr=$(ls -l pbe_delphi_*/run01.phi | awk '{print substr($NF, 1, index($NF, "/")-1) }')
fi

echo $fldr
