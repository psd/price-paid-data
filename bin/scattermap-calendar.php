#!/usr/bin/env php
<?php
    $imgdir = "../out/mapination";

    # return ISO date string for a julian date
    function jdtodate($jd) {
        list($month, $day, $year) = explode('/', jdtogregorian($jd));
        return sprintf("%4d-%02d-%02d", $year, $month, $day);
    }

    $width = '5mm';
    $ywidth = '40mm';

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
    color: #0b0c0c;
}
.page {
    position: relative;
    overflow: hidden;
    width: 915mm;
    height: 630mm;
    margin: 25mm 35mm 20mm 35mm;
}
.year {
    width: <?= $ywidth ?>;
    float: left;
    border-right: <?= $width ?> solid white;
    overflow: hidden;
    margin-top: 10mm;
}
.month {
    height: 45mm;
    margin-bottom: 2.5mm;
}
.letters {
    width: <?= $ywidth; ?>;
    overflow: hidden;
    height: 7.5mm;
    margin-top: 2.5mm;
}
h1 {
    font-size: 16mm;
}
h2 {
    font-weight: normal;
    text-align: center;
}
h3 {
    float: left;
    font-family: "Helvetica Neue";
    font-weight: normal;
    color: #aaa;
}
h2 {
    width: <?= $ywidth ?>;
}
h3 {
    display: block;
    width: <?= $width ?>;
    font-size: 2.5mm;
    text-align: right;
}
h4 {
    clear: both;
    width: 100%;
    text-align: center;
    color: #e82020;
    font-family: "Helvetica Neue";
    font-weight: lighter;
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
.day:after {
  content: "";
  background: white;
  position: absolute;
  top: 0;
  left: 0;
  height: 0.75mm;
  width: 2.25mm;
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
    position: absolute;
    bottom: 0mm;
    height: 20mm;
    font-family: "Helvetica Neue", "Helvetica", sans-serif;
    font-size: 5mm;
    font-weight: lighter;
    width: 100%;
}
.footer img.ogl {
    display: block;
    float: left;
    height: 12.5mm;
    padding-right: 7mm;
}
.footer p {
    display: block;
}
.footer span {
    padding-right: 1em;
}
a {
    text-decoration: none;
    color: #0b0c0c;
}
</style>
</head>
<body>
<div class="page">
<h1>Volume of Land Registry Transactions 1995–2014</h1>
<div class="calendar">
<?php
date_default_timezone_set("GMT");
$letters = array('S','M','T','W','T','F','S');

# one column per-year
#for ($year=1995; $year <= 2000; $year++) {
for ($year=1995; $year <= gmdate("Y"); $year++) {

    # year title
    echo "<div class='year year-$year'>\n";
    echo "<h2>$year</h2>\n";

    $monthsep = '';

    # days of the year
    for ($jd = gregoriantojd(1, 1, $year); $jd <= gregoriantojd(12, 31, $year); $jd++) {

        $date = jdtodate($jd);
        $weekday = jddayofweek($jd);
        $letter = $letters[$weekday];
        $mdate = substr($date, 0, 7);
        $month = substr($date, 5, 2);
        $dayno = substr($date, 8, 2);

        $monthname = date('F', mktime(0, 0, 0, $month, 10));

        $left = (intval(substr($date, -2)) -1) * 100;
        $file = "$imgdir/sprites-$mdate.gif";

        if ($dayno == '01') {
            echo $monthsep;
            $monthsep = "</div>\n</div>\n";

            echo "<div class='month'>\n";
            echo "<h4>$monthname</h4>\n";

            # day coulmn titles
            echo "<div class='letters'>\n";
            foreach($letters as $letter) {
                echo "  <h3>$letter</h3>\n";
            }
            echo "</div>\n";
            echo "<div class='days'>\n";

            # pad days in first week from previous month
            for ($padday = 0; $padday < $weekday; $padday++) {
                echo "<div class='day blank $month $year'><img class='spacer' src='$imgdir/blank.gif'></div>\n"; 
            }
        }

        # day
        echo "<div class='day y$year m$month d$dayno _$letter'>";
        echo "<img class='spacer' src='$imgdir/blank.gif' title='$date'>";
        if (file_exists("out/$file")) {
            echo "<img class='sprite' src='$file' style='left:-$left%' title='$date'>";
        }
        echo "</div>\n";
    }

    echo "</div>\n";
    echo "</div>\n";
    echo "</div>\n";
}
?>
<div class="footer">
    <img class="ogl" src="../images/ogl.png">
    <p>This poster was created by @psd from Land Registry price-paid open data as a part of the Land Registry Hackday, November 2014.</p>
    <p><span>Available from http://price-paid-data.whatfettle.com</span> © Crown copyright, published under the <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v3.0</a>.</p>
</div>
</div>
</body>
</html>
