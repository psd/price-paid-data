#!/bin/sh

#
#  create ImageMagick MVP commands for a scatterplot from a TSV timeseries
#  YYYY-MM-DD PRICE .. ..
#

#
#  command line options
#
usage() {
    echo "usage: $(basename $0) [-w width] [-h height] [-r radius] [-c color ] [-o opacity] [-m maximum]" >&2
    exit 1
}

width=2000
height=1000
radius=5
color=black
opacity=0.2
max=15000000

while getopts w:h:r:c:o:m: opt; do
  case $opt in
  w) width=$OPTARG ;;
  h) height=$OPTARG ;;
  r) radius=$OPTARG ;;
  c) color=$OPTARG ;;
  o) opacity=$OPTARG ;;
  m) max=$OPTARG ;;
  \?) usage ;;
  esac
done

#
#  set up the canvas
#
cat <<-!
viewbox 0 0 $width $height fill transparent rectangle 0,0 $width $height
fill $color
fill-opacity $opacity
!

#
#  draw points
#
awk -F'	' \
    -v width=$width \
    -v height=$height \
    -v radius=$radius \
    -v max=$max \
'
    function epoch(s) {
        gsub(/[:-]/, " ", s);
        s = s " 00 00 00"
        return mktime(s);
    }
    NR == 1 {
        first = epoch($1);
        last = systime() - first;
    }
    {
        this = epoch($1) - first;
        x = width * this / last;
        y = height - (height * $2 / max);
        printf "circle %d,%d,%d,%d\n", x, y, x+radius, y+radius;
    }
'
