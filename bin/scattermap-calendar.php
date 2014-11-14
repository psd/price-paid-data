#!/usr/bin/env php
<?php
    $imgdir = "../out/mapination";

    # return ISO date string for a julian date
    function jdtodate($jd) {
        list($month, $day, $year) = explode('/', jdtogregorian($jd));
        return sprintf("%4d-%02d-%02d", $year, $month, $day);
    }

    $ywidth = '42.5mm';
    $width = '8.5mm';

?><!DOCTYPE html>
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
    font-family: "Suisse Int'l Bold", "Helvetica Neue", sans-serif;
}
.page {
    width: 915mm;
    height: 630mm;
    overflow: hidden;
    border-bottom: 1px solid red;
}
.year {
    width: <?= $ywidth ?>;
    float: left;
    border-right: 3mm solid white;
    overflow: hidden;
    margin-top: 10mm;
}
.letters {
    width: <?= $ywidth; ?>;
    overflow: hidden;
    height: 7.5mm;
}
h2, h3 {
    display: block;
    float: left;
    font-weight: bold;
    text-align: center;
    color: #eee;
}
h2 {
    width: <?= $ywidth ?>;
}
h3 {
    width: <?= $width ?>;
}
.blank {
    min-width: <?= $width ?>;
}
.day {
  display: block;
  float: left;
  position: relative;
  overflow: hidden;
  height: <?= $width ?>;
  max-width: <?= $width ?>;
}
.day .spacer {
  width: <?= $width ?>;
  height: <?= $width ?>;
}
.day .sprite {
  position: absolute;
  top: 0;
  left: 0;
  max-width: none;
  max-height: 100%;
}
</style>
</head>
<body>
<div class="page">
<h1>Volume of Land Registry Transactions</h1>
<div class="calendar">
<?php
date_default_timezone_set("GMT");

# one column per-year
for ($year=1995; $year <= gmdate("Y"); $year++) {

    # year titles
    echo "<div class='year year-$year'>\n";
    echo "<h2>$year</h2>\n";

    # day coulmn titles
    $letters = array('S','M','T','W','T','F','S');
    echo "<div class='letters'>\n";
    foreach($letters as $letter) {
        if ($letter != 'S') {
            echo "  <h3>$letter</h3>\n";
        }
    }
    echo "</div>\n";

    # days in first week from previous year
    $firstday = jddayofweek(gregoriantojd(1, 1, $year));
    if ($firstday > 0) {
        for ($weekday = 0; $weekday < jddayofweek(gregoriantojd(1, 1, $year)); $weekday++) {
            $letter = $letters[$weekday];
            if ($letter != 'S') {
                echo "  <div class='day blank $letter'>&nbsp;</div>\n"; 
            }
        }
    }

    # days of the year
    for ($jd = gregoriantojd(1, 1, $year); $jd <= gregoriantojd(12, 31, $year); $jd++) {

        $date = jdtodate($jd);
        $weekday = jddayofweek($jd, 0);
        $letter = $letters[$weekday];
        $mdate = substr($date, 0, 7);
        $left = (intval(substr($date, -2)) -1) * 100;

        if ($letter != 'S') {
            echo "<div class='day'>";
            echo "<img class='spacer' src='$imgdir/1994-01-01.gif'>";
            echo "<img class='sprite' src='$imgdir/sprites-$mdate.gif' style='left:-$left%' title='$date'>";
            echo "</div>\n";
        }
    }
    echo "</div>\n";
}
?>
</div>
</body>
</html>
