#!/bin/sh
cat <<!
%!
%%Orientation: Landscape
%%Page: 1 1
0 0 0 setrgbcolor
/p {
    1 0 360 arc fill
} def
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
        x = 600 * this / last;
        y = 600 * $2 / max;
        printf "%d %d p\n", x, y;
    }'
echo showpage
