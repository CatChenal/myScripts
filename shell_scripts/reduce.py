#!/usr/bin/python

fort38 = open('fort.38').readlines()
unoccupied = []
for line in fort38:
   occ = line.split()
   sumocc = 0.0
   for x in occ[1:]:
      sumocc += float(x)
   if sumocc < 0.010: unoccupied.append(occ[0])

head3 = open('head3.lst').readlines()
head = []
for line in head3:
   occc = line.split()
   if line[21:22]== 't': head.append(occc[1])

for line in open('step2_out.pdb').readlines():
   keyword = line[17:20]+line[80:82]+line[21:30]
   if keyword[10] == ' ': keyword = keyword[:10] + '_' + keyword[11:]
   if keyword not in unoccupied or keyword in head: print line,
