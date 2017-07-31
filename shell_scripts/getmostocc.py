#!/usr/bin/python
import os
import sys
import math

if len(sys.argv) < 2:
  print "ERR_MISSING_ARG:   The column number in fort.38 is the sole and required argument of mostocc.py"
  print "                   To view the file header & select the right column, type:  head -1 fort.38"
  print "Examples:"
  print "Header: pH   0.0   1.0   2.0   3.0   4.0   5.0   6.0   7.0   8.0"
  print " Col #: 1     2     3     4     5     6     7     8     9    10"
  sys.exit(0)

column = int(sys.argv[1])
line_num = 0
exclude_memb = os.path.exists("mem_pos")

OccTable = {}
OccInRes = {}
	
# Get occupancy from fort.38 column corresponding to input (col number) 
fort38 = open("fort.38").readlines()
for line in fort38:
  line_num += 1
  # get confID
  fields = line.split()
  if len(fields) < column:
    print "ERR_FEWER_COLUMNS:        fort.38 in current dir has only ", len(fields), " columns"
    sys.exit(0)

  if len(fields[0]) == 14:
     # _CL-1A0466_001 1.000
    occ = float(fields[column-1])
    if occ == 0: continue
    confID = fields[0]
    OccTable[confID] = occ

for conf in OccTable.keys():
  resID = conf[:3]+conf[5:11]
#  print "resID:  ",resID
#resID:   PHEB0219_
#resID:   _CLA0467_

  if OccInRes.has_key(resID):
    OccInRes[resID].append((conf, OccTable[conf]))
  else:
    OccInRes[resID] = [(conf, OccTable[conf])]

# get max conf
maxConfs = []
for res in OccInRes.keys():
  confs = OccInRes[res]
  maxocc = confs[0]
  for conf in confs:
    if conf[1] > maxocc[1]:
      maxocc = conf
  maxConfs.append(maxocc[0])
#for x in maxConfs: print x

# read in a file and keep only the most occupied confs
pdb = open("step2_out.pdb").readlines()
#.         10        20        30        40        50        60        70        80
#0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
#ATOM  59063  CL  _CL A0466_001   4.701   7.631  -1.032   1.937      -1.000      -1O000M000
#ATOM      2  N   ARG P0017_000 -22.061 -15.228  28.007   1.500      -0.350      BK____M000
#[catalys@sibyl cl000]> grep A0466 fort.38
#_CL-1A0466_001 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000

outpdb = []
for line in pdb:
  if len(line) < 82: continue
  if line[26] == ' ': iCode = '_'
  else: iCode = line[26]
  confID = line[17:20]+line[80:82]+line[21:26]+iCode+line[27:30]
  if confID in maxConfs or confID[3:5] == 'BK':
    outpdb.append(line)

sys.stdout.writelines(outpdb)
