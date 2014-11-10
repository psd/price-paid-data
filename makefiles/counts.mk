COUNTS=\
	data/price.tsv\
	data/date.tsv\
	data/postcode.tsv\
	data/type.tsv\
	data/new.tsv\
	data/duration.tsv\
	data/paon.tsv\
	data/saon.tsv\
	data/street.tsv\
	data/locality.tsv\
	data/town.tsv\
	data/district.tsv\
	data/county.tsv\
	data/status.tsv

counts:	$(COUNTS)

data/price.tsv:	data/pp.tsv bin/count.sh
	cut -f1 data/pp.tsv | bin/count.sh > $@

data/date.tsv:	data/pp.tsv bin/count.sh
	cut -f2 data/pp.tsv | bin/count.sh > $@

data/postcode.tsv:	data/pp.tsv bin/count.sh
	cut -f3 data/pp.tsv | sed 's/ //g'| bin/count.sh > $@

data/type.tsv:	data/pp.tsv bin/count.sh
	cut -f4 data/pp.tsv | bin/count.sh > $@

data/new.tsv:	data/pp.tsv bin/count.sh
	cut -f5 data/pp.tsv | bin/count.sh > $@

data/duration.tsv:	data/pp.tsv bin/count.sh
	cut -f6 data/pp.tsv | bin/count.sh > $@

data/paon.tsv:	data/pp.tsv bin/count.sh
	cut -f7 data/pp.tsv | bin/count.sh > $@

data/saon.tsv:	data/pp.tsv bin/count.sh
	cut -f8 data/pp.tsv | bin/count.sh > $@

data/street.tsv:	data/pp.tsv bin/count.sh
	cut -f9 data/pp.tsv | bin/count.sh > $@

data/locality.tsv:	data/pp.tsv bin/count.sh
	cut -f10 data/pp.tsv | bin/count.sh > $@

data/town.tsv:	data/pp.tsv bin/count.sh
	cut -f11 data/pp.tsv | bin/count.sh > $@

data/district.tsv:	data/pp.tsv bin/count.sh
	cut -f12 data/pp.tsv | bin/count.sh > $@

data/county.tsv:	data/pp.tsv bin/count.sh
	cut -f13 data/pp.tsv | bin/count.sh > $@

data/status.tsv:	data/pp.tsv bin/count.sh
	cut -f14 data/pp.tsv | bin/count.sh > $@

