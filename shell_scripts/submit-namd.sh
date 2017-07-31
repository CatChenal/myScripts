#!/bin/sh
#$ -S /bin/sh
#$ -N namd
#$ -cwd
#$ -o namd_run.log
#$ -e namd_err.log

# Launch namd2:
/home/NAMD2.9/namd2 4H2H_gbis_mineq_v36.namd
##4H2H_ws_mineq_v36.namd
