# This:  getnon0sumcrg.cmd
# Cat Chenal (catchenal@gmail.com); 2010-06-15

awk '{sum=0; for(i=2; i<=NF; i++){sum+=$i};f=(NF+1); $f=sum; {if (f==17 && $17!=0) print $0}}' sum_crg.out > temp_get
# awk '{if (NR==1) gsub(/105/, "RowSum"); {print}}' temp_get > non0_sum_crg.out

awk '{if (NF==17) $17=""; print $0}' temp_get >non0_sum_crg.out

/bin/rm temp_get

cat non0_sum_crg.out
