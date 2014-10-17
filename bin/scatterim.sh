#!/bin/sh

width=2000
height=1000

cat <<-!
viewbox 0 0 $width $height fill transparent rectangle 0,0 $width $height
fill black
fill-opacity 0.2 
!
awk -F'	' \
    -v max=15000000 \
    -v radius=5 \
    -v width=$width \
    -v height=$height \
'
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
        x = width * this / last;
        y = height - (height * $2 / max);
        printf "circle %d,%d,%d,%d\n", x, y, x+radius, y+radius;
    }
'
