#!/usr/bin/env php
<?php
function draw_map($filename, $min_price=999999999, $max_price=0) {

    $map = array();

    # read data into an array
    $fp = fopen($filename, "r");
    while ($line = fgetcsv($fp, 0, '	')) {
        $price = $line[2];
        $a = array(
            "price" => $price
        );
        if ($price > 0 && $price < $min_price) $min_price = $price;
        if ($price > $max_price) $max_price = $price;
        $map[] = $a;
    }
    fclose($fp);

    foreach ($map as $n => $a) {
        if ($n % 32 > 3) {
            $price = $a['price'];

            $blank = $price == 0 ? " blank" : "";
            $c = round(8 * ($price - $min_price) / ($max_price - $min_price));
            $k = round($price / 1000);
            echo "<div class='point$blank q$c'>£${k}k</div>\n";
        }
    }
}

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
    height: 915mm;
    width: 630mm;
    margin: 25mm 35mm 20mm 35mm;
}
h1 {
    font-size: 16mm;
}
.footer {
    position: absolute;
    bottom: 0mm;
    height: 20mm;
    font-family: "Helvetica Neue", "Helvetica", sans-serif;
    font-size: 4mm;
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

.grid {
  width: 640mm;
  margin-top: 5mm;
}

.map {
  float: left;
  overflow: hidden;
  margin: 0 5mm;
  width: 140mm;
  height: 175mm;
  overflow: hidden;
}

.point {
  overflow: hidden;
  height: 4.9mm;
  width: 4.9mm;
  line-height: 4.9mm;
  margin: 0mm;
  background-color: #888;
  float: left;
  font-size: 1.5mm;
  text-align: center;
  font-family: "Helvetica Neue", "Helvetica", sans-serif;
  color: #fff;
  overflow: hidden;
}

.blank {
    color: #fff;
    background-color: #fff;
}

h2 {
    width: 100%;
    text-align: center;
}

.q0 {background-color:#f7fcf5}
.q1 {background-color:#e5f5e0}
.q2 {background-color:#c7e9c0}
.q3 {background-color:#a1d99b}
.q4 {background-color:#74c476}
.q5 {background-color:#41ab5d}
.q6 {background-color:#238b45}
.q7 {background-color:#006d2c}
.q8 {background-color:#00441b}

</style>
</head>
<body>
<div class="page">
<h1>Change in distribution of price paid for residential property</h1>
<div class="grid">
<?php
for ($year = 1995; $year <= 2014; $year++) {
    echo "<div class='map'>\n";
    draw_map("data/pricegrid/$year.tsv");
    echo "<h2>$year</h2>\n";
    echo "</div>\n";
}
?>
</div>

<div class="footer">
    <img class="ogl" src="../images/ogl.png">
    <p>This poster was created by @psd from Land Registry price-paid open data and is available from http://price-paid-data.whatfettle.com</p>
    <p>© Crown copyright, published under the <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v3.0</a>.</p>
</div>
</div>
</body>
</html>
