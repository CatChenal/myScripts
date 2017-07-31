#!/bin/bash

limit=2 # energy limit
vdw=4   # col4 of opp files
ele=3   # col3 of opp files

awk -v col="$vdw" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1A0466_00*.opp| sort|uniq > CLx_A_vdwpws_unfav_inter.csv
awk -v col="$vdw" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1A0467_00*.opp| sort|uniq > CLc_A_vdwpws_unfav_inter.csv
awk -v col="$vdw" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1A0468_00*.opp| sort|uniq > CLi_A_vdwpws_unfav_inter.csv

awk -v col="$ele" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1A0466_00*.opp| sort|uniq > CLx_A_elepws_unfav_inter.csv
awk -v col="$ele" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1A0467_00*.opp| sort|uniq > CLc_A_elepws_unfav_inter.csv
awk -v col="$ele" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1A0468_00*.opp| sort|uniq > CLi_A_elepws_unfav_inter.csv

awk -v col="$vdw" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1B0466_00*.opp| sort|uniq > CLx_B_vdwpws_unfav_inter.csv
awk -v col="$vdw" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1B0467_00*.opp| sort|uniq > CLc_B_vdwpws_unfav_inter.csv
awk -v col="$vdw" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1B0468_00*.opp| sort|uniq > CLi_B_vdwpws_unfav_inter.csv

awk -v col="$ele" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1B0466_00*.opp| sort|uniq > CLx_B_elepws_unfav_inter.csv
awk -v col="$ele" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1B0467_00*.opp| sort|uniq > CLc_B_elepws_unfav_inter.csv
awk -v col="$ele" -v lim="$limit" '{if ($col>lim) {print $2} }' energies/_CL-1B0468_00*.opp| sort|uniq > CLi_B_elepws_unfav_inter.csv

echo "Confs with ele and vdw pwise unfav for CL with cutoff of "$limit > CL_unfav.csv
ls -ltr CL*pws_unfav_inter.csv|awk 'BEGIN{OFS="\t"} {print $5,$6"-"$7"-"$8, $9}'|sort -k3 >> CL_unfav.csv
