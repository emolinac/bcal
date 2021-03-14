	use strict;
use warnings;

our %configuration;

#Los volumenes de las fibras se dividen en a y b para poder hacer el shift de posicion cada fila por medio y quede 
#una geometría simetrica

my $nrows = 5;  #Siempre impar por conveniencia. Numero de filas
my $ncols = 5;  #Siempre impar por conveniencia. Numero de columnas

my $nrowsa = ($nrows + 1)/2; #Numero de filas a
my $nrowsb = ($nrows - 1)/2; #Numero de filas b

#________Esquema de construccion de grid de fibras (ejemplo)_______#
#   A A A A A A A A A A A A
#    B B B B B B B B B B B 
#   A A A A A A A A A A A A 
#    B B B B B B B B B B B 
#   A A A A A A A A A A A A
#    B B B B B B B B B B B 
#   A A A A A A A A A A A A
#    B B B B B B B B B B B 
#   A A A A A A A A A A A A	
#Así se veria de frente un grid de fibras para $nrows=9 $ncols=12
#Se construyen primero los volumenes a! y desde adentro hacia afuera, es decir, primero se construyen los nucleos de las fibras a,
#luego el primer revestimiento de las fibras a y para finalizar el segundo revestimiento. Despues toca el turno de los volumenes b.

#_______________________ORDEN DE IDENTIFICACION________________________#
#Primero se identifican los volumenes a, luego los b, luego las placas de plomo que actuaran como "sensores" y finalmente el plomo
#en el cual esta ubicado el grid de fibras.
#En este caso los ids se dan de la siguiente forma:
#*nucleo fibra a 1-151
#*primer revestimiento a 152-302
#*segundo revestimiento a 303-454
#*nucleo fibra b 455-606
#*primer revestimiento a 607-758
#*segundo revestimiento a 759-910
#*primer sensor: 911
#*segundo sensor: 912
#*Volumen del plomo: 913

my $x = (0.1 * $ncols)/2. ; 
my $y = (0.1 + ($nrows - 1) * (0.05 * 1.732050808 + 0.05))/2. ;

sub makebcal
{
	build_lead();
	build_fiber_a();
	build_inclad_a();
	build_outclad_a();
	build_fiber_b();
	build_inclad_b();
	build_outclad_b();
	build_sensor_1();
	build_sensor_2();
}

sub build_lead
{
	#Novena tanda de identificacion
	my $xposlead = $x;
	my $yposlead = $y;
	my $leadid = 3 * $nrowsa * $ncols + 3 * $nrowsb * ($ncols - 1) + 1;
	my %detector = init_det();

	$detector{"name"}        = "lead_box";
	$detector{"mother"}      = "root";
	$detector{"description"} = "lead box which contains the fibers";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "7070702";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$x*cm $y*cm 2*cm";
	$detector{"material"}    = "G4_Pb";
	$detector{"mfield"}      = "no";
	$detector{"style"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"sensitivity"} = "flux";
	$detector{"hit_type"}    = "flux";
	$detector{"identifiers"} = "lead manual $leadid";
	
	print_det(\%configuration, \%detector);
}

sub build_fiber_a
{
	my $fibera_counter = 1;
    for(my $nx=0; $nx<$ncols;$nx++)
    {	
		for(my $ny=0; $ny<$nrowsa;$ny++)
		{
			#Primera tanda de identificacion
			my $ncore     = $fibera_counter;
			my $fiberposx = -$x + 0.05 + 2 * 0.05 * $nx;
			my $fiberposy = -$y + 0.05 + (0.05 * 1.732050808 + 0.05)* $ny * 2 ;

			my %detector = init_det();

			$detector{"name"}        = "core_$ncore";
			$detector{"mother"}      = "lead_box";
			$detector{"description"} = "$ny $nx th fiber in the lead box";
			$detector{"pos"}         = "$fiberposx*cm $fiberposy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "FFFFFF";
			$detector{"type"}        = "Tube";                            #Cilindro recostado en z
			$detector{"dimensions"}  = "0*cm 0.046*cm 2*cm 0*deg 360*deg"; 
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "fibera manual $ncore";
			print_det(\%configuration, \%detector);

			$fibera_counter += 1;
		}
    }
}

sub build_inclad_a
{
	my $inclada_counter = $nrowsa * $ncols + 1;
    for(my $nx=0; $nx<$ncols;$nx++)
    {	
		for(my $ny=0; $ny<$nrowsa;$ny++)
		{
			#Segunda tanda de identificacion
			my $ninclad     = $inclada_counter;
			my $incladposx = -$x + 0.05 + 2 * 0.05 * $nx;
			my $incladposy = -$y + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2 ;
			
			my %detector = init_det();

			$detector{"name"}        = "inclad_$ninclad";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$ny $nx th inclad in the lead box";
			$detector{"pos"}         = "$incladposx*cm $incladposy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "7CCBFF";
			$detector{"type"}        = "Tube";                            #Cilindro recostado en z
			$detector{"dimensions"}  = "0.046*cm 0.048*cm 2*cm 0*deg 360*deg"; 
			$detector{"material"}    = "inclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "inclada manual $ninclad";
			
			print_det(\%configuration, \%detector);
			
			$inclada_counter += 1;
		}
    }
}

sub build_outclad_a
{
	my $outclada_counter = 2 * $nrowsa * $ncols + 1;
    for(my $nx=0; $nx<$ncols;$nx++)
    {	
		for(my $ny=0; $ny<$nrowsa;$ny++)
		{
			#Tercera tanda de identificacion
			my $noutclad    = $outclada_counter;
			my $outcladposx = -$x + 0.05 + 2 * 0.05 * $nx;
			my $outcladposy = -$y + 0.05 + (0.05 * 1.732050808 + 0.05)* $ny * 2 ;
			
			my %detector = init_det();

			$detector{"name"}        = "outclad_$noutclad";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$ny $nx th outclad in the lead box";
			$detector{"pos"}         = "$outcladposx*cm $outcladposy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "0089E4";
			$detector{"type"}        = "Tube";                            #Cilindro recostado en z
			$detector{"dimensions"}  = "0.048*cm 0.05*cm 2*cm 0*deg 360*deg"; 
			$detector{"material"}    = "outclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "outclada manual $noutclad";
			
			print_det(\%configuration, \%detector);
			$outclada_counter += 1;
		}
    }
}


sub build_fiber_b
{
	my $fiberb_counter = 3 * $nrowsa * $ncols + 1;
    for(my $nx=0; $nx<($ncols-1);$nx++)
    {	
		for(my $ny=0; $ny<$nrowsb;$ny++)
		{
			#Cuarta tanda de identificacion
			my $ncore     = $fiberb_counter;
			my $fiberposx = 2 * 0.05 * $nx + 0.1 - $x;
			my $fiberposy = -$y + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;
			
			my %detector = init_det();

			$detector{"name"}        = "core_$ncore";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$ny $nx th fiber in the lead box";
			$detector{"pos"}         = "$fiberposx*cm $fiberposy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "FFFFFF";
			$detector{"type"}        = "Tube";                            #Cilindro recostado en z
			$detector{"dimensions"}  = "0*cm 0.046*cm 2*cm 0*deg 360*deg"; 
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "fiberb manual $ncore";
			print_det(\%configuration, \%detector);

			$fiberb_counter += 1;
		}
    }
}

sub build_inclad_b
{
	my $incladb_counter = 3 * $nrowsa * $ncols + $nrowsb * ($ncols - 1) + 1;
    for(my $nx=0; $nx<($ncols-1);$nx++)
    {	
		for(my $ny=0; $ny<$nrowsb;$ny++)
		{
			#Quinta tanda de identificacion
			my $ninclad     = $incladb_counter;
			my $incladposx = 2 * 0.05 * $nx + 0.1 - $x;
			my $incladposy = -$y + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;

			my %detector = init_det();

			$detector{"name"}        = "inclad_$ninclad";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$ny $nx th inclad in the lead box";
			$detector{"pos"}         = "$incladposx*cm $incladposy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "7CCBFF";
			$detector{"type"}        = "Tube";                            #Cilindro recostado en z
			$detector{"dimensions"}  = "0.046*cm 0.048*cm 2*cm 0*deg 360*deg"; 
			$detector{"material"}    = "inclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "incladb manual $ninclad";
			print_det(\%configuration, \%detector);

			$incladb_counter += 1;
		}
    }
}

sub build_outclad_b
{
	my $outcladb_counter = 3 * $nrowsa * $ncols + 2 * $nrowsb * ($ncols - 1) + 1;
    for(my $nx=0; $nx<($ncols-1);$nx++)
    {	
		for(my $ny=0; $ny<$nrowsb;$ny++)
		{
			#Sexta tanda de identificacion
			my $noutclad    = $outcladb_counter;
			my $outcladposx = 2 * 0.05 * $nx + 0.1 - $x;
			my $outcladposy = -$y + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;

			my %detector = init_det();

			$detector{"name"}        = "outclad_$noutclad";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$ny $nx th outclad in the lead box";
			$detector{"pos"}         = "$outcladposx*cm $outcladposy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "0089E4";
			$detector{"type"}        = "Tube";                            #Cilindro recostado en z
			$detector{"dimensions"}  = "0.048*cm 0.05*cm 2*cm 0*deg 360*deg"; 
			$detector{"material"}    = "outclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "outcladb manual $noutclad";
			print_det(\%configuration, \%detector);

			$outcladb_counter += 1;
		}
    }
}

sub build_sensor_1
{
	#Septima tanda de identificacion
	my $sensor1id = 3 * $nrowsa * $ncols + 3 * $nrowsb * ($ncols - 1) + 2;
	my %detector = init_det();

	$detector{"name"}        = "sensor1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "test sensor";
	$detector{"pos"}         = "0*cm 0*cm 2.1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "FFFFFF";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$x*cm $y*cm 0.1*cm"; 
	$detector{"material"}    = "G4_Al";
	$detector{"mfield"}      = "no";
	$detector{"style"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"sensitivity"} = "flux";
	$detector{"hit_type"}    = "flux";
	$detector{"identifiers"} = "sensor manual $sensor1id";
	print_det(\%configuration, \%detector);
}

sub build_sensor_2
{
	#Octava tanda de identificacion
	my $sensor2id = 3 * $nrowsa * $ncols + 3 * $nrowsb * ($ncols - 1) + 3;
	my %detector = init_det();

	$detector{"name"}        = "sensor2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "test sensor";
	$detector{"pos"}         = "0*cm 0*cm -2.1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "FFFFFF";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$x*cm $y*cm 0.1*cm"; 
	$detector{"material"}    = "G4_Al";
	$detector{"mfield"}      = "no";
	$detector{"style"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"sensitivity"} = "flux";
	$detector{"hit_type"}    = "flux";
	$detector{"identifiers"} = "sensor manual $sensor2id";
	print_det(\%configuration, \%detector);
}
