PP_COMPLETE_URL=http://publicdata.landregistry.gov.uk/market-trend-data/price-paid-data/a/pp-complete.csv
CSV_TO_TSV_URL=https://raw.githubusercontent.com/clarkgrubb/data-tools/master/src/csv_to_tsv.py

.DELETE_ON_ERROR:
.PHONY: makefiles

#
#  the dependency chain will emerge
#
all:	counts stats images

#
#  images
#
IMAGES=\
	out/scatterps.png \
	out/scatterim.png \
	out/scattergpi.png

images:	$(IMAGES)

# use gnuplot  to make a scatter plot
out/scattergpi.png:	data/prices.tsv bin/scatter.gpi
	@mkdir -p out
	bin/scatter.gpi < data/prices.tsv > $@
	optipng $@

# use ImageMagick to make a scatter plot
out/scatterim.png:	data/prices.tsv bin/scatterim.sh
	@mkdir -p out
	bin/scatterim.sh < data/prices.tsv | \
		convert mvg:- $@
	optipng $@

# use Postscript to make a scatter plot
out/scatterps.png:	data/prices.tsv bin/scatterps.sh
	@mkdir -p out
	bin/scatterps.sh < data/prices.tsv | \
		convert -density 300 - $@
	optipng $@

#
#  stats
#
data/prices.tsv:	data/pp.tsv
	awk -F'	' '{print $$2"	"$$1}' < data/pp.tsv | sort > $@

stats:	data/stats.tsv

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

#
#  counts
#
-include makefiles/counts.mk

makefiles: makefiles/counts.mk

makefiles/counts.mk:	bin/make-counts.sh etc/cols.tsv
	@mkdir -p makefiles
	bin/make-counts.sh > $@
