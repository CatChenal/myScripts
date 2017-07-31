#!/bin/sh

prtformat="%6-d%14s%2s%5.2d%-7.3d%6.0d%6.2d%3d%3d%7.3f%7.3f%7.3f%7.3f%7.3f%7.3f%12d"

awk '{printf($prtformat"\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)}' head3.lst.bkp > newformat

cat newformat
