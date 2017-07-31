awk 'NR==1{print $2,$(NF-5),$(NF-3)}' head3.lst
grep ' GLU-1A0148_072 ' head3.lst |nawk '{print $2,$(NF-5),$(NF-3)}' 
grep ' GLU02A0148_062 ' head3.lst |nawk '{print $2,$(NF-5),$(NF-3)}' 
grep ' GLU-1B0148_084 ' head3.lst |nawk '{print $2,$(NF-5),$(NF-3)}' 
grep ' GLU02B0148_071 ' head3.lst |nawk '{print $2,$(NF-5),$(NF-3)}' 
