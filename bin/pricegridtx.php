#!/usr/bin/env php
<?php
function draw_map($filename, $min_price, $max_price, $max_count, $width, $scale) {

    $map = array();

    # read data into an array
    $fp = fopen($filename, "r");
    while ($line = fgetcsv($fp, 0, '	')) {
        $a = array(
            "count" => $line[1],
            "price" => $line[2]
        );
        $map[] = $a;
    }
    fclose($fp);

    foreach ($map as $n => $a) {
        if ($n % 32 > 3) {
            $price = $a['price'];
            $blank = $price == 0 ? " blank" : "";
            $c = ($price == 0) ? "" : "q" . round(8 * ($price - $min_price) / ($max_price - $min_price));
            $k = round($price / 1000);
            $count = $a['count'];
            $s = $scale * pow($count / $max_count, 1/3);
            $o = ($width - $s) / 2;
            echo "<div class='box$blank'><div class='circle $c' style='width: ${s}mm; height: ${s}mm; top: ${o}mm; left: ${o}mm'></div><span>£${k}</span>k</div>\n";
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
    width: 330mm;
}
.footer span {
    padding-right: 1em;
}
a {
    text-decoration: none;
    color: #0b0c0c;
}

.map {
  width: 590mm;
  margin: 10mm auto;
}
.box {
  position: relative;
  width: 17mm;
  line-height: 17mm;
  margin: 2mm;
  float: left;
  text-align: center;
  font-size: 4mm;
  font-family: "Helvetica Neue", "Helvetica", sans-serif;
  color: #fff;
  text-shadow: -1px -1px 0 #888,  1px -1px 0 #888, -1px 1px 0 #888, 1px 1px 0 #888;
}

.blank {
  text-indent: -10000mm;
  color: #fff;
}

.circle {
  position: absolute;
  z-index: -1;
  border-radius: 50%;
  opacity: 0.25;
}

.yearly {
  width: 590mm;
  margin: 10mm auto;
}
.yearly .map {
  float: left;
  width: 56mm;
  height: 72mm;
  overflow: hidden;
}
.yearly .box {
  width: 2mm;
  height: 2mm;
  margin: 0mm;
  text-indent: -10000mm;
  white-space: nowrap;
}
h2 {
    width: 100%;
    text-align: center;
}

.q0 {background-color:rgb(255,245,240)}
.q1 {background-color:rgb(254,224,210)}
.q2 {background-color:rgb(252,187,161)}
.q3 {background-color:rgb(252,146,114)}
.q4 {background-color:rgb(251,106,74)}
.q5 {background-color:rgb(239,59,44)}
.q6 {background-color:rgb(203,24,29)}
.q7 {background-color:rgb(165,15,21)}
.q8 {background-color:rgb(103,0,13)}

.footer .key {
    float: right;
    width: 200mm;
}

.footer .key div {
    background-color:rgb(252,187,161);
    font-family: "Helvetica Neue", "Helvetica", sans-serif;
    font-weight: normal;
    color: #fff;
    text-align: right;
    float: left;
    margin-right: 2.5mm;
}

</style>
</head>
<body>
<div class="page">
<h1>Volume of transactions and price paid for residential property 1995–2014</h1>
<div class="main map"> <?php draw_map('data/pricegrid.tsv', 62000, 344000, 1200000, 17, 75); ?></div>
<div class="yearly">
<?php
for ($year = 1995; $year <= 2014; $year++) {
    echo "<div class='map'>\n";
    draw_map("data/pricegrid/$year.tsv", 19000, 750000, 80000, 2, 8);
    echo "<h2>$year</h2>\n";
    echo "</div>\n";
}
?>
</div>

<div class="footer">
    <div class="key">
        <p>Number of transactions:</p>
        <?php
        foreach (array("10k" => 10000, "100k" => 100000, "1M" => 1000000) as $s => $n) {
            $w = 75 * pow($n / 1200000, 1/3);
            echo "<div style='width: ${w}mm'>$s&nbsp;</div>\n";
        }
        ?>
    </div>
    <img class="ogl" src="../images/ogl.png">
    <p>This poster was created by @psd from Land Registry price-paid open data and is available from http://price-paid-data.whatfettle.com</p>
    <p>© Crown copyright, published under the <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v3.0</a>.</p>
</div>
</div>
</body>
</html>
