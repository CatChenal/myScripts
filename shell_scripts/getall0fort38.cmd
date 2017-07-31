nawk '{sum=0; for(n=2;n<=NF;n++){sum+=$n};tot=(NF+1);$tot=sum; {if(sum=0) print}}' fort.38 > all0fort.38;cat all0fort.38
