#!/usr/bin/env php
<?php
    $imgdir = "../out/mapination";

    # return ISO date string for a julian date
    function jdtodate($jd) {
        list($month, $day, $year) = explode('/', jdtogregorian($jd));
        return sprintf("%4d-%02d-%02d", $year, $month, $day);
    }

    $ywidth = '42.5mm';
    $width = '8mm';

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
    font-family: "Suisse Int'l", "Helvetica Neue", sans-serif;
}
.page {
    width: 915mm;
    height: 630mm;
    overflow: hidden;
    border-bottom: 1mm solid #888;
    padding: 35mm;
}
.year {
    width: <?= $ywidth ?>;
    float: left;
    border-right: 3mm solid white;
    overflow: hidden;
    margin-top: 15mm;
}
.letters {
    width: <?= $ywidth; ?>;
    overflow: hidden;
    height: 7.5mm;
}
h1 {
    font-size: 16mm;
}
h2, h3 {
    display: block;
    float: left;
    font-weight: bold;
    text-align: center;
    color: #888;
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
  border-left: 0.5mm solid white;
}
.d01:after {
  content: "";
  background: #444;
  position: absolute;
  top: 0;
  left: 0;
  height: 0.75mm;
  width: 2.25mm;
  opacity: 0.5;
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
.footer {
    clear: both;
    border-top: 25mm solid white;
    height: 15mm;
    font-family: "Helvetica Neue", "Helvetica", sans-serif;
    font-size: 7.75mm;
    font-weight: lighter;
    color: #888;
}
.footer img.ogl {
    display: block;
    float: left;
    height: 18mm;
    padding-right: 7mm;
}
.footer p {
    display: block;
}
.footer span {
    padding-right: 1em;
}
</style>
</head>
<body>
<div class="page">
<h1>Volume of Land Registry Transactions 1995–2014</h1>
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
        $month = substr($date, 5, 2);
        $dayno = substr($date, 8, 2);
        $left = (intval(substr($date, -2)) -1) * 100;
        $file = "$imgdir/sprites-$mdate.gif";

        if ($letter != 'S') {
            echo "<div class='day m$month d$dayno'>";
            echo "<img class='spacer' src='$imgdir/blank.gif' title='$date'>";
            if (file_exists("out/$file")) {
                echo "<img class='sprite' src='$file' style='left:-$left%' title='$date'>";
            }
            echo "</div>\n";
        }
    }
    echo "</div>\n";
}
?>
<div class="footer">
    <img class="ogl" src="../images/ogl.png">
    <p>This poster was created by @psd from Land Registry price-paid open data as a part of the Land Registry Hackday, November 2014.</p>
    <p><span>Available from https://github.com/LandRegistry/Hackday</span> © Crown copyright, published under the <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v3.0</a>.</p>
</div>
</div>
</body>
</html>
