#!/usr/bin/env awk -f

# draws histogram for a reverse sorted count file

BEGIN {
    FS="	"
}
NR == 1 {
    width = 65;
    max = $1;
}
{
    title = $2;
    size = width * ($1 / max);

    bar = "";
    for (i = 0; i < size; i++)
        bar = bar"#";

    count = sprintf("(%d)", $1);
    printf "%-15s %10s %s\n", title, count, bar;
}
