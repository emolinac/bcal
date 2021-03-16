#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/api/perl");
use utils;
use geometry;
use hit;
use bank;
use math;
use materials;

use Math::Trig;

# Make sure the argument list is correct
if( scalar @ARGV != 1)
{
	help();
	exit;
}

# Loading configuration file and paramters
our %configuration = load_configuration($ARGV[0]);

require "./bcal_materials.pl"; # Materials definitions.
require "./bcal_geometry.pl";  # Sensitive geometries.

my @allConfs = ("original");
foreach my $conf ( @allConfs )
{
	$configuration{"variation"} = $conf ;
	materials();
	makebcal();
}
