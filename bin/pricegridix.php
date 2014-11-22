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
        if ($n % 32 == 3) {
            #echo "<div class='hex-row'>\n";
        }
        if ($n % 32 > 3) {
            $price = $a['price'];
            $c = ($price == 0) ? "blank" : "q" . round(8 * ($price - $min_price) / ($max_price - $min_price));
            $even = $n % 2 ? "" : "even";
            $k = round($price / 1000);
            echo "  <div class='hex $c n$n $even'><div class='left'></div><div class='middle'>£${k}k</div><div class='right'></div></div>\n";
        }
        if ($n % 32 == 31) {
            #echo "</div>\n";
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
  margin: 0 15mm;
  width: 120mm;
  height: 170mm;
  overflow: hidden;
  position: relative;
}

h2 {
    width: 100%;
    text-align: center;
    position: absolute;
    z-index: -1;
    bottom: 5mm;
}

<?php
    $q = array('#f7fcf5', '#e5f5e0', '#c7e9c0', '#a1d99b', '#74c476', '#41ab5d', '#238b45', '#006d2c', '#00441b');

    foreach ($q as $n => $c) {
        echo ".hex.q$n .left { border-right: 1.41mm solid $c }\n";
        echo ".hex.q$n .middle { background-color: $c }\n";
        echo ".hex.q$n .right { border-left: 1.41mm solid $c }\n";
    }

?>

.hex.blank .left { border-right: 1.41mm solid transparent; }
.hex.blank .middle { background-color: solid transparent; color: transparent; }
.hex.blank .left { border-left: 1.41mm solid transparent; }

.hex {
    float: left;
    margin-right: -1.225mm;
    margin-bottom: -2.355mm;
}
.hex .right,
.hex .left {
    float: left;
    width: 0;
    border-top: 2.45mm solid transparent;
    border-bottom: 2.45mm solid transparent;
}
.hex .middle {
    float: left;
    width: 2.826mm;
    height: 4.9mm;
    line-height: 4.9mm;
    text-align: center;
    font-family: "Helvetica Neue", "Helvetica", sans-serif;
    font-size: 1mm;
    color: #fff;
}
.hex-row {
    clear: left;
}
.hex.even {
    margin-top: 2.5mm;
}

/* fixup */
.hex.n20 {
    margin-top: 5mm;
    margin-left: -4mm;
    padding-right: 2mm;
}
.hex.even.n966 {
    margin-left: 8.7mm;
}

</style>
</head>
<body>
<div class="page">
<h1>Distribution of price paid for residential property</h1>
<div class="grid">
<?php
for ($year = 1995; $year <= 2014; $year++) {
#for ($year = 1995; $year <= 1996; $year++) {
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
