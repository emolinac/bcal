use strict;
use warnings;

our %configuration;

sub materials
{
	# Scintillator
	my %mat = init_mat();
	$mat{"name"}          			= "core";
	$mat{"description"}   			= "core of the double cladded scintillating fiber";
	$mat{"density"}       			= "1.05";
	$mat{"ncomponents"}   			= "2";
	$mat{"components"}    			= "C 9 H 9";
	$mat{"photonEnergy"}            = "0.187*eV 0.224*eV 0.236*eV 0.28*eV 0.311*eV 0.33*eV 0.4*eV 10.45*eV";
	$mat{"indexOfRefraction"} 		= "1.572 1.576 1.577 1.582 1.587 1.592 1.606 1.617";
	$mat{"reflectivity"} 			= "0.001 0.001 0.001 0.001 0.001 0.001 0.001";
	$mat{"efficiency"}				= "0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3";#TEST VALUE
	$mat{"absorptionLenght"}		= "0.394*m 0.394*m 0.394*m 0.394*m 0.394*m 0.394*m 0.394*m 0.394*m";
	$mat{"slowtimeconstant"}		= "2.8*ns";
	$mat{"fasttimeconstant"}        = "0.9*ns";
	$mat{"rayleigh"}                = "0.394*m";
	$mat{"yieldratio"}				= "0.9";	#TEST VALUE
	$mat{"scintillationyield"}		= "8000";   #TEST VALUE
	print_mat(\%configuration, \%mat);

	my %mat2 = init_mat();
	$mat2{"name"} 					= "inclad";
	$mat2{"description"} 			= "Inner cladding of the Scintillator";
	$mat2{"density"} 				= "1.19";
	$mat2{"ncomponents"} 			= "3";
	$mat2{"components"} 			= "O 2 C 5 H 8";
	$mat2{"photonEnergy"}  			= "0.447*eV";
	$mat2{"indexOfRefraction"} 		= "1.49";
	$mat2{"reflectivity"} 			= "0.00057";
	$mat2{"absorptionLenght"}		= "0.394*m";
	$mat2{"slowtimeconstant"}		= "2.8*ns";
	$mat2{"rayleigh"}                = "0.394*m";
	print_mat(\%configuration, \%mat2);

	my %mat3 = init_mat();
	$mat3{"name"} 					= "outclad";
	$mat3{"description"} 			= "Outter cladding of the Scintillator";
	$mat3{"density"} 				= "1.42";
	$mat3{"ncomponents"} 			= "3";
	$mat3{"components"} 			= "O 2 C 5 H 8";
	$mat3{"photonEnergy"}  			= "0.447*eV";
	$mat3{"indexOfRefraction"} 		= "1.42";
	$mat3{"reflectivity"}			= "0.03";
	$mat3{"absorptionLenght"}		= "0.0002*cm";
	$mat3{"slowtimeconstant"}		= "2.8*ns";
	$mat3{"rayleigh"}               = "0.0002*cm";
	print_mat(\%configuration, \%mat3);
}
