# Call:
# awk -v col_dsol=7 -v col_res=10 -f get-pK-stats.awk [file]

function max(x){
        i=0;
        for(val in x){
                if(i<=x[val]){i=x[val];}
        }return i
}
function min(x){
        i=max(x);
        for(val in x){
                if(i>x[val]){i=x[val];}
        }return i
}
{dsolv[col_dsol]=$col_dsol; res[col_res]=$col_res;next}
END{
        min_dsolv=min(dsolv);max_dsolv=max(dsolv);
        min_res=min(res);max_res=max(res);
        print "Max dsolv: "max_dsolv" - Min: "min_dsolv"\n   Max res: "max_res" - Min: "min_res;
}

