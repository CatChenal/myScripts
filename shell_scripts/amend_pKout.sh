#/bin/bash
# To correct for format & omission due to Yifan's MC (s4)
# so that mfe.py can be used
#
if [[ $# -eq 0 ]]; then
  subdir='./'
else
  subdir=$1'/'
fi

 sed -i 's/^\(...\) /\1+/; s/GLU+/GLU-/; s/ASP+/ASP-/' $subdir'pK.out'
 sed -i '/CL/d' $subdir'pK.out'

  for CL in $(echo "_CL-A0466_ _CL-A0467_ _CL-A0468_ _CL-B0466_ _CL-B0467_ _CL-B0468_")
  do
    sedARG="'\$a "$CL"        0.000     0.000     0.000'"
    # echo "$sedARG"
    eval sed -i "$sedARG"  $subdir'pK.out'
  done

if [[ -f 'cl000/pK.out' ]]; then
  sed -i '/CL/d' cl000/pK.out
fi
