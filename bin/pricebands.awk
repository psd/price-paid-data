#!/usr/bin/env awk -f

# collate a csv of years and price bands into data for a stacked chart

function print_prices(date, counts) {
    printf "%s", date;
    for (band= 0; band <= 4; band++) {
        count = counts[band];
        if (!count) {
            count = 0;
        }
        printf ",%d", count;
    }
    printf "\n";
}
BEGIN {
    FS="	"
    print "Year,£60k and under,£61k to £250k,£251k to £500k,£501k to £1M,Over £1M"
}
{
    lines++;
    date = $1;
    sub("-.*$", "", date);

    price = $2 / 1000;
    if (price <= 60) { counts[0]++ }
    else if (price <= 250) { counts[1]++ }
    else if (price <= 500) { counts[2]++ }
    else if (price <= 1000) { counts[3]++ }
    else { counts[4]++ }

    # next date, print row
    if (date_last && date_last != date) {
        print_prices(date_last, counts);
        lines = 0;
        delete counts;
    }
    date_last = date;
}
END {
    if (lines) {
        print_prices(date_last, counts);
    }
}
