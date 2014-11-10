#!/usr/bin/env perl

#
#  generate a scatter map image for each day
#
use strict;
use warnings;

my $geocodes = shift || "data/codepo_gb.tsv";
my $outdir = shift || "out/mapination";
my $width = 256;
my $height = 256;
my $colors = 64;
my $radius = 1;
my $opacity = 0.1;
my $max_easting = 700000;
my $max_northing = 700000;
my %postcode = ();

load_postcodes($geocodes);

#
# read  generate a scattermap for each day .. 
#
my ($date, $last_date, $count, $postcode);
my @points = ();
while (<>) {
    chomp;
    ($count, $date, $postcode) = split(/\t/, $_);
    if (defined($last_date) && $date ne $last_date) {
        create_image($last_date, \@points);
        @points = ();
    }
    push(@points, {postcode => $postcode, count => $count});
    $last_date = $date;
}
create_image($date, \@points) if @points;

#
#  create an image
#
sub create_image {
    my ($date, $points) = @_;
    my $out = "$outdir/$date.gif";
    system("mkdir -p $outdir") unless (-d $outdir);
    print STDERR "creating $out ..\n";
    open(my $fp, "| convert -colors $colors -font 'helvetica' -annotate +5+15 '$date' mvg: $out");
    print $fp <<HEADER;
viewbox 0 0 $width $height fill transparent rectangle 0,0 $width $height
fill black
fill-opacity $opacity
HEADER
    foreach my $p (@$points) {
        my $c = $postcode{$p->{postcode}};
        next unless $c;
        my $x = $width * $c->{easting} / $max_easting;
        my $y = $height - ($height * $c->{northing} / $max_northing);
        my $size = $p->{count} * $radius;
        printf($fp "circle %d,%d,%d,%d\n", $x, $y, $x+$size, $y+$size);
    }
    close($fp);
}

#
#  read open postcodes into memory
#
sub load_postcodes {
    my ($geocodes) = @_;
    open my $file, "<", $geocodes or die "unable to open $geocodes";
    while (my $line = <$file>) {
        my ($postcode, $easting, $northing) = split /\t/, $line;
        $postcode{$postcode} = { easting => $easting, northing => $northing };
    }
}
