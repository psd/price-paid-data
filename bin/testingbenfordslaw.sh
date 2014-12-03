#!/bin/bash
# format price-paid statistics in JSON for http://testingbenfordslaw.com/
# depends upon benfordprices.tsv and stats.tsv

export LC_NUMERIC=en_GB.UTF-8

eval $(sed 's/	/=/' data/stats.tsv)
num_records=$(printf "%'.0f" "$count")
min_value=$(printf "%'.0f" $min)
max_value=$(printf "%'.0f" $max)

cat <<-!
{
  "values": {
!

sep=""
sort -k2 data/benfordprices.tsv |
while read occurs digit
do
    percent=$(bc -l <<< "scale=2; 100 * $occurs / $count")
    echo -n "$sep    \"$digit\": $percent"
    sep=',
'
done

cat <<-!

  },
  "num_records": "$num_records",
  "min_value": "$min_value",
  "max_value": "$max_value",
  "source": "https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads"
}
!
