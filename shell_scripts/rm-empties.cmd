ls -l | awk '{if ( $5 == 0 ) print "rm "$8}' | grep -v rem0 > rem0 | chmod +x rem0 |. rem0
/bin/rm rem0
