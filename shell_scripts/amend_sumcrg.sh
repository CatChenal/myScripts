#!/bin/bash
# To correct for format & omission due to Yifan's MC (s4)
#
if [[ ! -f sum_crg.out ]]; then
  echo Exiting: sum_crg.out not found
  exit 0
fi

check=$(awk 'NR==2{print length($1);exit}' sum_crg.out)

if [[ $check -eq 3 ]]; then  # ARG A002 -> ARG+A002
    sed -i 's/^\(...\) /\1+/; s/_CL_/_CL-/; s/GLU+/GLU-/; s/ASP+/ASP-/; s/TYR+/TYR-/; s/Net crg  /Net_crg__ /^ $/d' sum_crg.out
fi
