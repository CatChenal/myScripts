#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage:  res-confs-stat.sh res-id# (e.g. 0148 - not just 148)"
  exit 0
else

  here=`pwd`
  fldr=`basename "$here"`
  res=$1
  crg=$2

  echo "$fldr" - Conformers of "$res":
  echo "Total:       `grep -c "$res" fort.38`"

  echo "Neutral:     `grep "$res" fort.38|grep -c '0._'`"

  echo "Charged:     `grep "$res" fort.38|grep -cv '0._'`"

  echo "Occupied:    `grep -c "$res" fort.38.non0`:"
	grep "$res" fort.38.non0
fi
