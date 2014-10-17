#!/bin/sh

cat <<-!
viewbox 0 0 1000 1000   fill white  rectangle 0,0 1000 1000
fill black
fill-opacity 0.2 
!

awk -F'	' -v max=15000000 '
    function epoch(s) {
        gsub(/[:-]/, " ", s);
        s = s " 00 00 00"
        return mktime(s);
    }
    NR == 1 {
        first = epoch($1);
        last = systime() - first;
    }
    {
        this = epoch($1) - first;
        x = 1000 * this / last;
        y = 1000 - (1000 * $2 / max);
        printf "circle %d,%d,%d,%d\n", x, y, x+1, y+1;
    }' 
