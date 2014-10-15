PP_COMPLETE_URL=http://publicdata.landregistry.gov.uk/market-trend-data/price-paid-data/a/pp-complete.csv
CSV_TO_TSV_URL=https://raw.githubusercontent.com/clarkgrubb/data-tools/master/src/csv_to_tsv.py

.DELETE_ON_ERROR:
.PHONY: makefiles

all:	counts stats

stats:	data/stats.tsv

# bootstrap by make makefiles
-include makefiles/counts.mk

data/stats.tsv:	data/pp.tsv bin/stats.sh
	cut -f1 data/pp.tsv | bin/stats.sh > $@

data/pp.tsv:	bin/csv-to-tsv.py
	@mkdir -p data
	curl -s $(PP_COMPLETE_URL) | \
	iconv -f ISO-8859-1 -t UTF-8 | \
	bin/csv-to-tsv.py | \
	cut -d'	' -f2- | \
	sed -e 's/ 00:00//' > data/pp.tsv

bin/csv-to-tsv.py:
	curl -s $(CSV_TO_TSV_URL) > $@
	chmod +x $@

makefiles: makefiles/counts.mk

makefiles/counts.mk:	bin/make-counts.sh etc/cols.tsv
	@mkdir -p makefiles
	bin/make-counts.sh > $@
