PP_COMPLETE_URL=http://publicdata.landregistry.gov.uk/market-trend-data/price-paid-data/a/pp-complete.csv
CSV_TO_TSV_URL=https://raw.githubusercontent.com/clarkgrubb/data-tools/master/src/csv_to_tsv.py
CODEPO_GB_URL=http://parlvid.mysociety.org/os/codepo_gb-2014-08.zip

.DELETE_ON_ERROR:
.PHONY: makefiles

#
#  the dependency chain will emerge
#
all:	counts stats images posters

#
#  posters
#
POSTERS=\
	posters/scattermap-calendar.pdf \
	posters/pricegrid.pdf

#
#  images
#
IMAGES=\
	out/scatterps.png \
	out/scatterim.png \
	out/scattergpi.png \
	out/scatterzoom.png \
	out/price.png \
	out/pricefreq.png \
	out/pricerank.png \
	out/pricetens.png \
	out/pricehundreds.png \
	out/pricethousands.png \
	out/pricelog.png \
	out/priceheat.png \
	out/priceheat.ps \
	out/yearly.png \
	out/pricesmooth.png \
	out/mapscatterim.png \
	out/scattermap.png \
	out/mapination/daily-2007.gif \
	out/mapination/blank.gif \
	html/scattermap-calendar.html \
	html/pricegrid.html

STATS=\
	data/stats.tsv \
	data/pricebands.csv

MONTHS=01 02 03 04 05 06 07 08 09 10 11 12

posters:	$(POSTERS)

images:	$(IMAGES)

# minimal viable choropleth
posters/pricegrid.pdf:	html/pricegrid.html
	@mkdir -p posters
	wkhtmltopdf -q --page-size a1 --orientation portrait html/pricegrid.html /tmp/pricegrid.pdf
	pdftk /tmp/pricegrid.pdf cat 1 output $@

html/pricegrid.html:	data/pricegrid.tsv bin/pricegrid.php data/pricegrid/1995.tsv
	bin/pricegrid.php >$@

posters/scattermap-calendar.pdf:	html/scattermap-calendar.html
	@mkdir -p posters
	wkhtmltopdf -q --page-size a1 --orientation landscape html/scattermap-calendar.html /tmp/scattermap-calendar.pdf
	pdftk /tmp/scattermap-calendar.pdf cat 1 output $@

# poster of daily mapination scatter map plots
html/scattermap-calendar.html:	out/mapination/sprites-1995-01.gif bin/scattermap-calendar.php
	php -l bin/scattermap-calendar.php
	bin/scattermap-calendar.php > $@

out/mapination/sprites-1995-01.gif:	out/mapination/1995-01-01.gif
	for year in `seq 1995 2014` ; do \
	  for month in $(MONTHS); do \
		if [ -f "out/mapination/$$year-$$month-01.gif" ] ; then \
			convert out/mapination/$$year-$$month-??.gif +append -extent 8192x256 out/mapination/sprites-$$year-$$month.gif;\
		fi \
	  done \
	done

out/mapination/blank.gif:
	convert -size 10x10 xc:white $@

# daily mapination animated gif scatter map plot for each year
out/mapination/daily-2007.gif:	out/mapination/2014-01-01.gif
	for year in `seq 1995 2014` ; do gifsicle --delay 33 out/mapination/$$year-??-??*.gif > out/mapination/daily-$$year.gif ; done

out/mapination/2014-01-01.gif: bin/mapination.pl data/codepo_gb.tsv data/daily-postcode.tsv
	bin/mapination.pl data/codepo_gb.tsv out/mapination < data/daily-postcode.tsv

# ImageMagick scatter map plot
out/scattermap.png:	data/postcodes_os.tsv bin/scattermap.sh
	@mkdir -p out
	bin/scattermap.sh < data/postcodes_os.tsv | convert mvg:- $@
	#optipng $@

# map for the poster
out/mapscatterim.png:	data/postcodes_os.tsv bin/mapscatterim.sh
	@mkdir -p out
	bin/mapscatterim.sh < data/postcodes_os.tsv | convert mvg:- $@
	optipng $@

# R smooth LOESS curve
out/pricesmooth.png:	data/prices.tsv bin/pricesmooth.R
	@mkdir -p out
	bin/pricesmooth.R
	optipng $@

# gnuplot price yearly histogram
out/yearly.png:	data/yearly.tsv bin/yearly.gpi
	@mkdir -p out
	bin/yearly.gpi < data/yearly.tsv > $@
	optipng $@

# gnuplot price heatmap eps
out/priceheat.ps:	data/priceheat.tsv bin/priceheatps.gpi
	@mkdir -p out
	bin/priceheatps.gpi < data/priceheat.tsv > $@

# gnuplot price heatmap
out/priceheat.png:	data/priceheat.tsv bin/priceheat.gpi
	@mkdir -p out
	bin/priceheat.gpi < data/priceheat.tsv > $@
	optipng $@

# gnuplot price lower digits 1000
out/pricelog.png:	data/pricethousands.tsv bin/pricelog.gpi
	@mkdir -p out
	bin/pricelog.gpi < data/pricethousands.tsv > $@
	optipng $@

# gnuplot price lower digits 1000
out/pricethousands.png:	data/pricethousands.tsv bin/pricedigits.gpi
	@mkdir -p out
	bin/pricedigits.gpi < data/pricethousands.tsv > $@
	optipng $@

# gnuplot price lower digits 100
out/pricehundreds.png:	data/pricehundreds.tsv bin/pricedigits.gpi
	@mkdir -p out
	bin/pricedigits.gpi < data/pricehundreds.tsv > $@
	optipng $@

# gnuplot price lower digits 10
out/pricetens.png:	data/pricetens.tsv bin/pricedigits.gpi
	@mkdir -p out
	bin/pricedigits.gpi < data/pricetens.tsv > $@
	optipng $@

# gnuplot price rank
out/pricerank.png:	data/price.tsv bin/pricerank.gpi
	@mkdir -p out
	bin/pricerank.gpi < data/price.tsv > $@
	optipng $@

# gnuplot price (v) number sold histogram
out/pricefreq.png:	data/price.tsv bin/pricefreq.gpi
	@mkdir -p out
	bin/pricefreq.gpi < data/price.tsv > $@
	optipng $@

# gnuplot price (v) number sold scatter plot
out/price.png:	data/price.tsv bin/price.gpi
	@mkdir -p out
	bin/price.gpi < data/price.tsv > $@
	optipng $@

# gnuplot scatter plot
out/scattergpi.png:	data/prices.tsv bin/scatter.gpi
	@mkdir -p out
	bin/scatter.gpi < data/prices.tsv > $@
	optipng $@

out/scatterzoom.png:	data/prices.tsv bin/scatterzoom.gpi
	@mkdir -p out
	bin/scatterzoom.gpi < data/prices.tsv > $@
	optipng $@

# ImageMagick scatter plot
out/scatterim.png:	data/prices.tsv bin/scatterim.sh
	@mkdir -p out
	bin/scatterim.sh < data/prices.tsv | \
		convert mvg:- $@
	optipng $@

# Postscript scatter plot
out/scatterps.png:	data/prices.tsv bin/scatterps.sh
	@mkdir -p out
	bin/scatterps.sh < data/prices.tsv | \
		convert -density 300 - $@
	optipng $@

#
#  stats
#
data/pricegrid.tsv:	data/pp.tsv bin/pricegrid.pl data/codepo_gb.tsv
	cut -d'	' -f1,3 data/pp.tsv | bin/pricegrid.pl data/codepo_gb.tsv > $@

# brute-force yearly price-grids
data/pricegrid/1995.tsv:	data/pp.tsv bin/pricegrid.pl data/codepo_gb.tsv
	mkdir -p data/pricegrid
	for year in `seq 1995 2014` ; do \
		awk -F'	' '$$2 ~ /^'$$year'/ {print $$1 "	" $$3 }' data/pp.tsv | bin/pricegrid.pl data/codepo_gb.tsv > data/pricegrid/$$year.tsv ;\
	done

data/pricebands.csv:	data/prices.tsv bin/pricebands.awk
	bin/pricebands.awk < data/prices.tsv > $@

data/priceheat.tsv:	data/prices.tsv bin/priceheat.awk
	bin/priceheat.awk < data/prices.tsv > $@

data/daily-postcode.tsv:	data/pp.tsv
	cut -d'	' -f2,3 data/pp.tsv | sed -e 's/ //' | awk '$$2' | bin/count.sh | sort -k2 > $@

# count transactions per-year
data/yearly.tsv:	data/pp.tsv
	cut -f2 < data/pp.tsv | sed 's/-.*//' | sort | uniq -c | awk '{print $$2 "	" $$1}' > $@

# count price bands
data/pricetens.tsv:	data/pp.tsv
	cut -f1 < data/pp.tsv | awk '{ print $$1 % 10 }' | bin/count.sh > $@

data/pricehundreds.tsv:	data/pp.tsv
	cut -f1 < data/pp.tsv | awk '{ print $$1 % 100 }' | bin/count.sh > $@

data/pricethousands.tsv:	data/pp.tsv
	cut -f1 < data/pp.tsv | awk '{ print $$1 % 10000 }' | bin/count.sh > $@

data/prices.tsv:	data/pp.tsv
	awk -F'	' '{print $$2"	"$$1}' < data/pp.tsv | sort > $@

# postcode to eastings/northings
data/postcodes_os.tsv:	data/codepo_gb.tsv data/postcodes.tsv
	join -t'	' data/codepo_gb.tsv data/postcodes.tsv > $@

data/codepo_gb.tsv: tmp/codepo_gb.zip
	unzip -o -d tmp/codepo_gb tmp/codepo_gb.zip
	cat tmp/codepo_gb/Data/CSV/* | sed -e 's/[ "]//g' -e 's/,/	/g' | cut -d'	' -f1,3,4 | sort > $@

data/postcodes.tsv:	data/postcode.tsv
	cat data/postcode.tsv | sed 's/ //g' | awk '{print $$2 "	" $$1}' | sort > $@

stats:	$(STATS)

# basic price-paid statistics
data/stats.tsv:	data/pp.tsv bin/stats.awk
	cut -f1 data/pp.tsv | bin/stats.awk > $@

# convert CSV to TSV
data/pp.tsv:	data/pp-complete.csv bin/csv-to-tsv.py bin/csv-to-tsv.sh
	bin/csv-to-tsv.sh < data/pp-complete.csv > $@

# download price paid dataset
data/pp-complete.csv:
	curl -s $(PP_COMPLETE_URL) > $@

# install CSV to TSV conveter
bin/csv-to-tsv.py:
	@mkdir -p data
	curl -s $(CSV_TO_TSV_URL) > $@
	chmod +x $@

# download OS Code-Point-Open
tmp/codepo_gb.zip:
	@mkdir -p tmp
	curl -s $(CODEPO_GB_URL) > $@

#
#  counts
#
-include makefiles/counts.mk

makefiles: makefiles/counts.mk

makefiles/counts.mk:	bin/make-counts.sh etc/cols.tsv
	@mkdir -p makefiles
	bin/make-counts.sh > $@
