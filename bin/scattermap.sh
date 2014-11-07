#!/bin/sh

#
#  create ImageMagick MVP commands for a scatterplot from a TSV of easting/northings:
#
#  POSTCODE EASTING NORTHING COUNT
#

#
#  command line options
#
usage() {
    echo "usage: $(basename $0) [-w width] [-h height] [-r radius] [-c color ] [-o opacity] [-m maximum]" >&2
    exit 1
}

width=7000
height=13000
radius=0.25
color=black
opacity=0.05
xmax=700000
ymax=1300000

while getopts w:h:r:c:o:m: opt; do
  case $opt in
  w) width=$OPTARG ;;
  h) height=$OPTARG ;;
  r) radius=$OPTARG ;;
  c) color=$OPTARG ;;
  o) opacity=$OPTARG ;;
  x) xmax=$OPTARG ;;
  y) ymax=$OPTARG ;;
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
    -v xmax=$xmax \
    -v ymax=$ymax \
'
    {
        x = width * $2 / xmax;
        y = height - (height * $3 / ymax);
        count = $4
        size = radius * count
        printf "circle %d,%d,%d,%d\n", x, y, x+size, y+size;
    }
'
