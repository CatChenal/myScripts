#!/bin/bash

res=$1

echo "res: " $res

case "$res" in
  ASP*|GLU*)
  CRGID=$res"-1"
  ;;
  ARG*|HIS*|LYS*)
  CRGID=$res"+1"
  ;;
  *)
  CRGID=9
  ;;
esac
echo "$CRGID"

#...........................................
mfe_file="bfkjdbv"

  if [[ $mfe_file != s* ]]; then
   echo "File does not start with s: "$mfe_file
  fi


