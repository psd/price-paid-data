#!/bin/sh

# count lines from stdin, output as reverse-sorted TSV

sort |
uniq -c |
sort -rn |
sed -e 's/^ *//' -e 's/  */	/' -e 's/ *$//'
