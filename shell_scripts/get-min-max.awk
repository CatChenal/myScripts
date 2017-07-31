#!/usr/bin/nawk -f

# Call:
# nawk get-min-max.awk -v col_to_calc=7 -v col_out=10 -v val_hdr -v out_hdr -f infile
# col_out= column to outpout in addition to col1.
# x_hdr variables: for printing

function max(x){i=0;for(val in x){if(i<=x[val]){i=x[val];}}return i;}
function min(x){i=max(x);for(val in x){if(i>x[val]){i=x[val];}}return i;}
/^#/{next}

{val[col_to_calc]=$col_to_calc; out[col_out]=$col_out;next}
END{    min_val=min(val);max_val=max(val);
        min_out=min(out);max_out=max(out);
        print "Max "val_hdr": "max_val" - Min: "min_val"\n   Max "out_hdr": "max_val" - Min: "min_val;
}
