#!/bin/bash

#To cleanup progress.log to get stat:

sed -i -e '/Relaxation Cycle /d; /Relaxation: /d; /for hydrogen relaxation/d ' progress.log
sed -i -e 's/=  /=/g; s/= /=/g' progress.log

#[catalys@sibyl WTnew_W]> 
awk '{print $1,$2, $5,$6}'  progress.log |sort -k3nr > confs_neighbors.csv

echo 'Conformers with more than 12 neighbors:'

awk '$3>12' confs_neighbors.csv
