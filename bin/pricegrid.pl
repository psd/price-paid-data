#!/usr/bin/env perl

#
#  generate a grid of average prices suitable for turning into a choropleth map
#
use strict;
use warnings;
use POSIX;

my $geocodes = shift || "data/codepo_gb.tsv";
my $width = 32;
my $height = 32;
my $max_easting = 660000;
my $max_northing = 660000;
my %postcode = ();

load_postcodes($geocodes);

#
#  create grid
#
my @grid = ();
foreach my $n (0 .. $width*$height) {
    $grid[$n] = {count => 0, average => 0};
}

#
#  read prices and calculate averages
#
while (<>) {
    chomp;
    my ($price, $postcode) = split(/\t/, $_);
    $postcode =~ s/ //g;
    my $n = $postcode{$postcode};
    if (defined($n)) {
        my $count = $grid[$n]->{count};
        my $average = $grid[$n]->{average};
        $average = ($price + ($average*$count)) / ($count + 1);
        $count = $count + 1;
        $grid[$n] = {count => $count, average => $average};
    }
}

#
#  write grid
#
foreach my $n (0..@grid) {
    print "$n\t" . $grid[$n]->{count} . "\t" .  floor($grid[$n]->{average}) . "\n";
}

#
#  load open postcodes into memory
#
sub load_postcodes {
    my ($geocodes) = @_;
    open my $file, "<", $geocodes or die "unable to open $geocodes";
    while (my $line = <$file>) {
        my ($postcode, $easting, $northing) = split /\t/, $line;
        $postcode{$postcode} = floor($width * $easting / $max_easting)
            + $width * ($height - floor($height * $northing / $max_northing) - 1);
    }
}
