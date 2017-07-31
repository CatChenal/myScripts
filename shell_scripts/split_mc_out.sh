#!/bin/bash

if [[ ! -f mc_out ]]; then
  echo "File mc_out not found: rerun Step4 without minimizing output files."
  exit 0
fi

cp mc_out mc_out.bkp

sed -n '/Conformer/,$p' mc_out.bkp > mc_out.tbl

/bin/rm mc_out.bkp
