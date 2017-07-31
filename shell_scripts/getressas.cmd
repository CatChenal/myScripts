grep -v 0.000 acc.res |awk '{print $0|"sort +1 -2 +2 -3"}'|egrep 'ARG|ASP|CYS|GLU|HIS|LYS|SER|TYR' > sas-res.info
