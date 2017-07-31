# Call syntax: awk -f sumrows.awk < file
# 
# Assumption: first col is descriptive (no numbers).
#

{ for(i=2; i<=NF; i++){sum[i]+=$i}}{print} END {for(i=2; i<=NF; i++){printf "%d\t" sum[i]}}' allCLs.38.non0

# { for (i=2; i<=NF; i++) { sum[i]+= $i } }
# END { for (i=2; i<=NF; i++) { print sum[i] } }
