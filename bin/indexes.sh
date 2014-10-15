#!/bin/sh

# find the occurrence of each value in each column

while read column title
do
    echo :: $title ::

    time (
        cat data/pp.tsv |
        cut -d'	' -f$column |
        sort |
        uniq -c |
        sort -rn |
        sed -e 's/^ *//' -e 's/  */⋯/g' 
    ) > data/$title.tsv

done  < etc/cols.tsv
