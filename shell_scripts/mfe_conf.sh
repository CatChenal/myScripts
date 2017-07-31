#!/bin/bash

fileout=$1".mfe"

mfe++ $1 1 1 > $fileout
awk '{print; if ($1=="SUM") {exit}}' $fileout > $fileout".csv"
/bin/rm $fileout
