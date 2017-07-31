#!/bin/bash
# to be called in the folder to process
if [[ $# -lt 2 ]]; then
  echo "Missing: folder id and CL_dir to process [subset folder]"
  echo $0 " to be called in the folder to process"
  exit 0
fi
pH=4.5
cutoff=0.9

fldr=$1
cl_dir=$2

CL_only=0
if [[ $# -eq 4 ]]; then
  CL_only=$4
fi
#read -p "Only do mfe on CL? (1/0)" CL_only

if [[ $# -eq 3 ]]; then
  subset=$3
  E148file=$fldr"-"$subset"-"$cl_dir"-E148_mfe2.csv"
  E203file=$fldr"-"$subset"-"$cl_dir"-E203_mfe2.csv"
  cd $subset"/"$cl_dir
else
  E148file=$fldr"-"$cl_dir"_E148_mfe2.csv"
  E203file=$fldr"-"$cl_dir"_E203_mfe2.csv"
  cd $cl_dir
fi
  if [[ $CL_only -ne 1 ]]; then
    mfe.py GLU-A0148_ $pH $cutoff >> tmp
    mfe.py GLU-B0148_ $pH $cutoff >> tmp
    sed -e 's/Residue //; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/  xxx /; s/\([0-9]\)\(-[0-9]\)/\1 \2/' tmp |awk '$3!=0 {print $1"\t"$2"\t"$4"\t"$5}' > $E148file
    /bin/rm tmp
    mfe.py GLU-A0203_ $pH $cutoff >> tmp
    mfe.py GLU-B0203_ $pH $cutoff >> tmp
    sed -e 's/Residue //; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/  xxx /; s/\([0-9]\)\(-[0-9]\)/\1 \2/' tmp |awk '$3!=0 {print $1"\t"$2"\t"$4"\t"$5}' > $E203file
    /bin/rm tmp
  else
    CLfile=$fldr"-"$cl_dir"_CL466_mfe2.csv"
    mfe.py _CL-A0466_ $pH $cutoff >> tmp
    mfe.py _CL-B0466_ $pH $cutoff >> tmp
    sed -e 's/Residue //; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/  xxx /; s/\([0-9]\)\(-[0-9]\)/\1 \2/' tmp |awk '$3!=0 {print $1"\t"$2"\t"$4"\t"$5}' > $CLfile
    /bin/rm tmp

    CLfile=$fldr"-"$cl_dir"_CL467_mfe2.csv"
    mfe.py _CL-A0467_ $pH $cutoff >> tmp
    mfe.py _CL-B0467_ $pH $cutoff >> tmp
    sed -e 's/Residue //; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/  xxx /; s/\([0-9]\)\(-[0-9]\)/\1 \2/' tmp |awk '$3!=0 {print $1"\t"$2"\t"$4"\t"$5}' > $CLfile
    /bin/rm tmp

    CLfile=$fldr"-"$cl_dir"_CL468_mfe2.csv"
    mfe.py _CL-A0468_ $pH $cutoff >> tmp
    mfe.py _CL-B0468_ $pH $cutoff >> tmp
    sed -e 's/Residue //; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/  xxx /; s/\([0-9]\)\(-[0-9]\)/\1 \2/' tmp |awk '$3!=0 {print $1"\t"$2"\t"$4"\t"$5}' > $CLfile
    /bin/rm tmp
  fi

  if [[ "$fldr" =~ "R..L" ]]; then
    /bin/mv *mfe2.csv ../../.
  else
    /bin/mv *mfe2.csv ../.
  fi
cd ../
