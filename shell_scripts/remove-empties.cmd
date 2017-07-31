 ls -l|awk '$5==0 {print "rm "$NF}'>empty.cmd
. empty.cmd
