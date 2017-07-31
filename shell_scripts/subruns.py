#!/usr/bin/python
# This program splits a working directory into subdirctories that can run partial delphi.
# Watch-out: MCCE version hard-coded
import sys, os, zlib
import os.path 
os.path.isfile(fname) 
JOBS_MAX = 16

def print_help():
   print " subruns.py : help  ->  subruns.py n_steps"
   print
   print "   This program divides Step3 of MCCE into working subdirectories, which"
   print "   contain sets of conformers setup for Delphi calc (Step3), and prepares a submit script."
   print "   n_steps: size of the conformers set to be placed into a subdirectory for Delphi calculation."
   print
   print "   If you split the conformers number properly, Step3 can be at least 10 times faster."
   print "   Note: dirs = n_confs/n_steps; dirs = 16: max number of jobs that can run on sibyl at the same time."
   print " ..........................."
   return

def print_next():
   print " subruns.py : help  ->  What to do once Step3 is over in the subdirectories"
   print 
   print " 0. Make sure you are in the parent working directory."
   print " 1. Copy head3.lst & energies.opp from a subdirectory into the parent working dir, i.e.: 'cp sub001/head3.lst .; cp sub001/energies.opp .'"
   print " 2. Use the command 'zopp -u sub*' [-u = update mode] to merge the subdirs."
   print " 3. Amend run.prm Step flag & run Step4."
   print " ..........................."
   return

def split_dirs(n_steps):
   
   # create a run.prm template
   runprm = open("run.prm").readlines()
   lines = []
   for line in runprm:
      if   line.find("(DO_PREMCCE)") >=0:
         line = "f        step 1: pre-run, pdb-> mcce pdb                    (DO_PREMCCE)\n"
      elif line.find("(DO_ROTAMERS)") >=0:
         line = "f        step 2: make rotatmers                             (DO_ROTAMERS)\n"
      elif line.find("(DO_ENERGY)") >=0:
         line = "t        step 3: do energy calculations                     (DO_ENERGY)\n"
      elif line.find("(DO_MONTE)") >=0:
         line = "f        step 4: monte carlo sampling                       (DO_MONTE)\n"
      # mcce version 2.5:
      elif line.find("(PBE_START)") >=0:
         line = "#START#  pbe start conformer number, 0 based             (PBE_START)\n"
      elif line.find("(PBE_END)") >=0:         
         line = "#END#    pbe end conformer number, self included         (PBE_END)\n"
      # prior versions:
      elif line.find("(DELPHI_START)") >=0:
         line = "#START#  delphi start conformer number, 0 based             (DELPHI_START)\n"
      elif line.find("(DELPHI_END)") >=0:
         line = "#END#    delphi end conformer number, self included         (DELPHI_END)\n"

      lines.append(line)

   # number of sub directories      
   n_dirs = n_confs/n_steps + 1	
   
   # create sub directories, copy run.prm and step2_out.pdb
   for i in range(n_dirs):
      dir_name = "sub%03d" % (i+1)
      try:
         os.mkdir(dir_name)
      except:
         pass
      fp = open("%s/run.prm"%dir_name, "w")
      for line in lines:
         fp.write(line.replace("#START#", "%d" % (i*n_steps+1)).replace("#END#", "%d" % ((i+1)*n_steps)))
      fp.close()
      try:
         os.remove("%s/step2_out.pdb" % dir_name)
         os.remove("%s/new.tpl" % dir_name)
      except:
         pass
      os.symlink("../step2_out.pdb", "%s/step2_out.pdb" % dir_name);
      os.symlink("../new.tpl", "%s/new.tpl" % dir_name);

   # creat a sge submit file "msubmit.sh"
   if not os.system("which qsub > /dev/null") :
      lines = []
      lines.append("#!/bin/bash\n")
      lines.append("curpath=`pwd`\n")
      lines.append("for sub in `ls -d sub*/`\n")
      lines.append("do\n")
      lines.append("    cd ${curpath}/${sub}\n")
      lines.append("    ln -s ../submit.sh .\n")
      lines.append("    qsub submit.sh\n")
      lines.append("done\n")
      open("S3-subruns-submit.sh", "w").writelines(lines)
      os.chmod("S3-subruns-submit.sh", 0755)
      print "Split-S3-runs submit script created (S3-subruns-submit.sh): amend step flags in run.prm & execute to submit."

   # create condor_submit file
   if not os.system("which condor_submit > /dev/null"): 
      lines = []
      lines.append("Executable = /home/mcce/mcce2.4.4/mcce\n")
      lines.append("Universe = vanilla\n")
      lines.append("error   = condor.err\n")
      lines.append("output  = run.log\n")
      lines.append("Log     = condor.log\n")
      lines.append("getenv   = true\n")
      lines.append("Notification = never\n\n")
      for i in range(n_dirs):
         lines.append("Initialdir = sub%03d\n" % (i+1))
         lines.append("queue\n\n")
      open("submit", "w").writelines(lines)

   return
#.....................................................................
# Amended MAIN so that n_steps value is first suggested using
# JOBS_MAX=16 when user is prompted for value.
#.....................................................................
if __name__ == "__main__":
# Get n_steps from user:
# Enter your input: [x*5 for x in range(2,10,3)]
# Received input is :  [10, 25, 40]
# jobs_max = 16 = n_confs/n_steps => n_confs/16 = n_steps

   if os.path.isfile("head2.lst"):
      n_confs = len(open("head2.lst").readlines()) - 1
      n_steps = int(n_confs/JOBS_MAX)
#   n_steps = int(sys.argv[1])

     steps = int(raw_input("Enter your preferred number of steps (suggested number is %d ): ", n_steps));
     print "Received input is : ", steps

   else
      print " head2.lst not found."
      print " ..........................."
      sys.exit()

   if  steps < 2:
        print_help()
        print " The given n_steps value is less than 2: if this is correct, there is no need for splitting runs."
        print " ..........................."
        sys.exit()

   split_dirs(steps)
   print_next()
