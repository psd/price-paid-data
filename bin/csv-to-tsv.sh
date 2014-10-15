#!/bin/sh

iconv -f ISO-8859-1 -t UTF-8 |
	bin/csv-to-tsv.py |
	cut -d'	' -f2- |
	sed -e 's/ 00:00//'
