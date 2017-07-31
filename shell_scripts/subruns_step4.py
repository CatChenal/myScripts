#!/usr/bin/python
# This program creates a working directory <folder> and splits step 4 of mcce into several folders 
# step3 version by Junjun Mao - adapted to step4 by Christian Fufezan 
#

import sys, os, zlib

def print_help():
   print "subruns_step4.py <folder> <ph|eh> <start titration point> <end titration point> <steps size> <head3.lst>"
   print "   This program divides step 4 of MCCE "
   return

def bp():
   print "`------- --       -                       [exiting]          -"
   sys.exit()

def split_dirs():
   # create a run.prm template
   runprm = open("run.prm").readlines()
   lines = []
   for line in runprm:
     if line.find("(DO_PREMCCE)") >=0:
         line = "f        step 1: pre-run, pdb-> mcce pdb                    (DO_PREMCCE)\n"
     elif line.find("(DO_ROTAMERS)") >=0:
         line = "f        step 2: make rotatmers                             (DO_ROTAMERS)\n"
     elif line.find("(DO_ENERGY)") >=0:
         line = "f        step 3: do energy calculations                     (DO_ENERGY)\n"
     elif line.find("(DO_MONTE)") >=0:
         line = "t        step 4: monte carlo sampling                       (DO_MONTE)\n"
     elif line.find("(TITR_TYPE)") >=0:
        line = ttype.lower() + '      "ph" for pH titration, "eh" for eh titration       (TITR_TYPE)\n'
     elif line.find("(TITR_PH0)") >=0 and ttype == 'PH':
         line = "#START#      Initial pH                                         (TITR_PH0)\n"
     elif line.find("(TITR_PHD)") >=0:         
         line = "1      pH interval                                        (TITR_PHD)\n"
     elif line.find("(TITR_EH0)") >=0 and ttype == 'EH':
        line = "#START#      Initial Eh                                         (TITR_EH0)\n"
     elif line.find("(TITR_EHD)") >=0:         
        line = "1      Eh interval (in mV)                                (TITR_EHD)\n"
     elif line.find("(TITR_STEPS)") >=0:         
         line = "1       Number of titration points                         (TITR_STEPS)\n"
         
     lines.append(line)
   

   # number of sub directories      
   n_dirs = (endpts - strpts) / ssize
   if (n_dirs > 20):
       print " Are you craZy or WoOt ?-> " + str(n_dirs) + " Titrationpoints ? - NoWay :P"
       bp()
   
   if (os.path.exists(folder)):
      print '- Folder ' + str(folder) + ' already exists ... '
      #bp()
   else:
      os.mkdir(folder)
   os.symlink("../run.prm", str(folder + "/split.dir")) # This is the recognizion flag for the submit script dosubruns
   a = 1
   i=strpts
   while (a > 0):
      dir_name = folder + "/sub_%.2f" % (i)
      if (not os.path.exists(dir_name)):
          os.mkdir(dir_name)
      fp = open((dir_name + "/run.prm"), "w")
      for line in lines:
        fp.write(line.replace("#START#", "%.2f" % (i)))
      fp.close()
      print " Processed folder " + str(i)
      
      if (not os.path.exists((dir_name + "/energies.opp"))):
          os.symlink("../../energies.opp", str(dir_name + "/energies.opp"))
          os.symlink("../../energies", str(dir_name + "/energies"))
      if (not os.path.exists((dir_name + "/head3.lst"))):
          os.symlink(str("../../"+head3lst), str(dir_name + "/head3.lst"))
      
      
      i=i+ssize
      if (i > endpts):
         break
   return
   
if __name__ == "__main__":
   print ".-------------------"
   if len(sys.argv) != 7:
      print_help()
      bp()
   
   else:
      folder = str(sys.argv[1])
      ttype = str(sys.argv[2]).upper()
      strpts = float(sys.argv[3])
      endpts = float(sys.argv[4])
      ssize = float(sys.argv[5])
      head3lst = str(sys.argv[6])
      split_dirs()
      print "`------- --       -             -"
      
# by Ch. Fufezan
