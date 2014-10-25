#!/usr/bin/env awk -f

# collate a tsv of dates and prices into data for a heat map

BEGIN {
    FS="	"
    price_unit = 10000;
    price_max = 60;
}
{
    date = $1;
    sub("-[0-9][0-9]$", "", date);

    price = $2 / price_unit;

    counts[price]++;

    # next date, print row
    if (date_last && date_last != date) {
        for (price= 0; price <= price_max; price++) {
            count = counts[price];
            if (!count) {
                count = 0;
            }
            printf "%s %d %d\n", date_last, price, count;
        }
        printf "\n";
    }
    date_last = date;
}
