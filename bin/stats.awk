#!/usr/bin/env awk -f

NR == 1 {
    min = $1;
    max = $1;
}
{
    if ($1 < min) min = $1;
    if ($1 > max) max = $1;
    sum += $1;
    sumsq += $1 * $1
}
END {
    printf "count\t%d\n", NR
    printf "min\t%d\n", min
    printf "max\t%d\n", max
    printf "sum\t%d\n", sum
    printf "mean\t%f\n", sum/NR
    printf "sd\t%f\n", sqrt(sumsq/NR - (sum/NR)**2)
}
