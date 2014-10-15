#!/bin/sh

# make makefile for counting, a real hack!

printf COUNTS=
while read column title
do
    printf '\'
    printf "$sep\n\tdata/$title.tsv"
done  < etc/cols.tsv

echo
echo
printf "counts:\t\$(COUNTS)\n"
echo

while read column title
do
printf "data/$title.tsv:\tdata/pp.tsv bin/count.sh\n"
printf "\tcut -f$column data/pp.tsv | bin/count.sh > \$@\n"
echo
done  < etc/cols.tsv
