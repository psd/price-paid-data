PP_COMPLETE_URL=http://publicdata.landregistry.gov.uk/market-trend-data/price-paid-data/a/pp-complete.csv
CSV_TO_TSV_URL=https://raw.githubusercontent.com/clarkgrubb/data-tools/master/src/csv_to_tsv.py

.DELETE_ON_ERROR:
.PHONY: makefiles

all:	counts stats images

stats:	data/stats.tsv

images:	out/scatterps.png

out/scatterps.png:	data/prices.tsv
	@mkdir -p out
	bin/scatterps.sh < data/prices.tsv | \
		convert -density 300 - $@

data/prices.tsv:	data/pp.tsv
	awk -F'	' '{print $$2"	"$$1}' < data/pp.tsv | sort > $@

# bootstrap by make makefiles
-include makefiles/counts.mk

data/stats.tsv:	data/pp.tsv bin/stats.awk
	cut -f1 data/pp.tsv | bin/stats.awk > $@

data/pp.tsv:	data/pp-complete.csv bin/csv-to-tsv.py bin/csv-to-tsv.sh
	bin/csv-to-tsv.sh < data/pp-complete.csv > $@

data/pp-complete.csv:
	curl -s $(PP_COMPLETE_URL) > $@

bin/csv-to-tsv.py:
	@mkdir -p data
	curl -s $(CSV_TO_TSV_URL) > $@
	chmod +x $@

makefiles: makefiles/counts.mk

makefiles/counts.mk:	bin/make-counts.sh etc/cols.tsv
	@mkdir -p makefiles
	bin/make-counts.sh > $@
