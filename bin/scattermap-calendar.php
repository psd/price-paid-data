#!/usr/bin/env php
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
* {
    padding: 0;
    margin: 0;
    border: none;
}
body {
    font-family: "Helvetica Neue", sans-serif;
}
.page {
    width: 915mm;
    height: 630mm;
    overflow: hidden;
}
td {
  vertical-align: top;
}
.calendar {
    margin-top: 5mm;
}
caption, th {
    font-weight: bold;
    color: #eee;
}
.year td {
    position: relative;
    overflow: hidden;
    width: 10mm;
    height: 10mm;
}
.S {
    display: none;
}
.year td img {
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    width: 100%;
}
</style>
</head>
<body>
<div class="page">
<h1>Volume of Land Registry Transactions</h1>
<table class="calendar">
<tr>
<?php
date_default_timezone_set("GMT");

$imgdir = "../out/mapination/";

# one column per-year
for ($year=1995; $year <= gmdate("Y"); $year++) {

    # year titles
    echo "<td>\n";
    echo "<table class='year-$year year'>\n";
    echo "<caption>$year</caption>\n";

    # day coulmn titles
    $letters = array('S','M','T','W','T','F','S');
    echo "<tr>\n";
    foreach($letters as $letter) {
        echo "    <th class='header $letter'>$letter</th>\n";
    }
    echo "</tr>\n";

    # days in first week from previous year
    $firstday = jddayofweek(gregoriantojd(1, 1, $year));
    if ($firstday > 0) {
        echo "<tr>\n";
        for ($weekday = 0; $weekday < jddayofweek(gregoriantojd(1, 1, $year)); $weekday++) {
            $letter = $letters[$weekday];
            echo "    <td class='blank $letter'>&nbsp;</td>\n"; 
        }
    }

    # days of the year
    for ($jd = gregoriantojd(1, 1, $year); $jd <= gregoriantojd(12, 31, $year); $jd++) {

        $month = jdmonthname($jd, 0);
        $weekday = jddayofweek($jd, 0);
        list($monthno, $monthday, $y) = explode('/', jdtogregorian($jd));

        $date = sprintf("%4d-%02d-%02d", $year, $monthno, $monthday);
        $letter = $letters[$weekday];

        if ($weekday == 0) {
            echo "<tr>\n";
        }
        echo "    <td id='$date' class='day $letter jd_$jd $month'>";
        #printf("<img src='%ssprites-%04d-%02d.gif' style='left:-%d%s'>", $imgdir, $year, $monthno, ($monthday-1)/32*100, '%');
        echo "<img src='$imgdir$date.gif' title='$date'>";
        echo "</td>\n";
        if ($weekday == 6) {
            echo "</tr>\n";
        }
    }
    echo "</tr>\n</table>\n</td>\n";
}
?>
</tr></table>
</div>
</body>
</script>
</html>
