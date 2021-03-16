use strict;
use warnings;

our %configuration;

# Los volúmenes de las fibras se dividen en a y b para poder hacer el shift de posición cada fila
# por medio y quede una geometría simétrica.

my $nrows = 7;  # Siempre impar por conveniencia. Número de filas.
my $ncols = 7;  # Siempre impar por conveniencia. Número de columnas.

my $nrowsa = ($nrows + 1)/2; # Número de filas a.
my $nrowsb = ($nrows - 1)/2; # Número de filas b.

my $flength = 1.99;

# === Esquema de construcción de grilla de fibras ($nrows=9 $ncols=12) =============================
#   A A A A A A A A A A A A
#    B B B B B B B B B B B
#   A A A A A A A A A A A A
#    B B B B B B B B B B B
#   A A A A A A A A A A A A
#    B B B B B B B B B B B
#   A A A A A A A A A A A A
#    B B B B B B B B B B B
#   A A A A A A A A A A A A
# Se construyen primero los volúmenes a desde adentro hacia afuera, es decir, primero se construyen
# los núcleos de las fibras a, luego el primer revestimiento de las fibras a y para finalizar el
# segundo revestimiento. Después toca el turno de los volúmenes b.

# === Orden de Identificación ======================================================================
# volumen  | id
# lead_box | 0
# fiber    | %1d (a=0, b=1) 1 %4d (nx) %4d (ny)
# inclad   | %1d (a=0, b=1) 2 %4d (nx) %4d (ny)
# outclad  | %1d (a=0, b=1) 3 %4d (nx) %4d (ny)
# sensor1  | %1d (a=0, b=1) 4 %4d (nx) %4d (ny)
# sensor2  | %1d (a=0, b=1) 5 %4d (nx) %4d (ny)
# Los ids son generados como 10**9 * (a or b) + 10**8 * vol_id + 10**4 * nx + 10**0 * ny.

my $Dx = (0.1 * $ncols)/2.;
my $Dy = (0.1 + ($nrows - 1) * (0.05 * 1.732050808 + 0.05))/2.;

sub makebcal {
	build_lead();
	build_fiber_a();
    build_inclad_a();
	build_outclad_a();
    build_sensor_1a();
    build_sensor_2a();
	build_fiber_b();
    build_inclad_b();
	build_outclad_b();
    build_sensor_1b();
    build_sensor_2b();
}

sub generate_id {
    if ($_[1] >= 10) {die "row_id should be between 0 (a) and 1 (b)!";}
    if ($_[0] >= 10) {die "vol_id should be between 1 and 5!";}
    if ($_[2] >= 10**4) {die "nx should be between 0 and 10**4!";}
    if ($_[3] >= 10**4) {die "ny should be between 0 and 10**4!";}
    my $vol_id = 10**9 * $_[1];
    my $row_id = 10**8 * $_[0];
    my $nx     = 10**4 * $_[2];
    my $ny     = 10**0 * $_[3];
    return $vol_id + $row_id + $nx + $ny;
}

sub build_lead {
	my $xposlead = $Dx;
	my $yposlead = $Dy;
	my $id = 0;
	my %detector = init_det();

	$detector{"name"}        = "lead_box";
	$detector{"mother"}      = "root";
	$detector{"description"} = "lead box container";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "7070702";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$Dx*cm $Dy*cm 2*cm";
	$detector{"material"}    = "G4_Pb";
	$detector{"mfield"}      = "no";
	$detector{"style"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"sensitivity"} = "flux";
	$detector{"hit_type"}    = "flux";
	$detector{"identifiers"} = "lead manual $id";

	print_det(\%configuration, \%detector);
}

sub build_fiber_a {
    for (my $nx=0; $nx<$ncols; $nx++) {
		for (my $ny=0; $ny<$nrowsa; $ny++) {
			my $id   = generate_id(1, 0, $nx, $ny);
			my $posx = -$Dx + 0.05 + 2 * 0.05 * $nx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05)* $ny * 2;
			my %detector = init_det();

			$detector{"name"}        = "core_$id";
			$detector{"mother"}      = "lead_box";
			$detector{"description"} = "$nx $ny fiber a";
			$detector{"pos"}         = "$posx*cm $posy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "FFFFFF";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0*cm 0.046*cm $flength*cm 0*deg 360*deg";
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "fiber_a manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_inclad_a {
    for (my $nx=0; $nx<$ncols; $nx++) {
		for (my $ny=0; $ny<$nrowsa; $ny++) {
			my $id   = generate_id(2, 0, $nx, $ny);
			my $posx = -$Dx + 0.05 + 2 * 0.05 * $nx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2;
			my %detector = init_det();

			$detector{"name"}        = "inclad_$id";
			$detector{"mother"}      = "lead_box";
			$detector{"description"} = "$nx $ny inclad a";
			$detector{"pos"}         = "$posx*cm $posy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "7CCBFF";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0.046*cm 0.048*cm $flength*cm 0*deg 360*deg";
			$detector{"material"}    = "inclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "inclad_a manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_outclad_a {
    for (my $nx=0; $nx<$ncols; $nx++) {
		for (my $ny=0; $ny<$nrowsa; $ny++) {
			my $id   = generate_id(3, 0, $nx, $ny);
			my $posx = -$Dx + 0.05 + 2 * 0.05 * $nx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05)* $ny * 2;
			my %detector = init_det();

			$detector{"name"}        = "outclad_$id";
			$detector{"mother"}      = "lead_box";
			$detector{"description"} = "$nx $ny outclad a";
			$detector{"pos"}         = "$posx*cm $posy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "0089E4";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0.048*cm 0.05*cm $flength*cm 0*deg 360*deg";
			$detector{"material"}    = "outclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "outclad_a manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_sensor_1a {
    for (my $nx=0; $nx<$ncols; $nx++) {
		for (my $ny=0; $ny<$nrowsa; $ny++) {
			my $id   = generate_id(4, 0, $nx, $ny);
			my %detector = init_det();

			$detector{"name"}        = "sensor_$id";
			$detector{"description"} = "$nx $ny sensor1 a";
            $detector{"mother"}      = "lead_box";
            my $posx = -$Dx + 0.05 + 2 * 0.05 * $nx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05)* $ny * 2;
            $detector{"pos"}         = "$posx*cm $posy*cm -1.99*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "339999";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0*cm 0.046*cm 0.01*cm 0*deg 360*deg";
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "sensor1_a manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_sensor_2a {
    for (my $nx=0; $nx<$ncols; $nx++) {
		for (my $ny=0; $ny<$nrowsa; $ny++) {
			my $id   = generate_id(5, 0, $nx, $ny);
			my %detector = init_det();

			$detector{"name"}        = "sensor_$id";
            $detector{"description"} = "$nx $ny sensor2 a";
            $detector{"mother"}      = "lead_box";
            my $posx = -$Dx + 0.05 + 2 * 0.05 * $nx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05)* $ny * 2;
            $detector{"pos"}         = "$posx*cm $posy*cm 1.99*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "339999";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0*cm 0.046*cm 0.01*cm 0*deg 360*deg";
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "sensor2_a manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}

sub build_fiber_b {
    for (my $nx=0; $nx<($ncols-1); $nx++) {
		for (my $ny=0; $ny<$nrowsb; $ny++) {
			my $id   = generate_id(1, 1, $nx, $ny);
			my $posx = 2 * 0.05 * $nx + 0.1 - $Dx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;
			my %detector = init_det();

			$detector{"name"}        = "core_$id";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$nx $ny fiber b";
			$detector{"pos"}         = "$posx*cm $posy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "FFFFFF";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0*cm 0.046*cm $flength*cm 0*deg 360*deg";
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "fiber_b manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_inclad_b {
    for(my $nx=0; $nx<($ncols-1); $nx++) {
		for(my $ny=0; $ny<$nrowsb; $ny++) {
			my $id   = generate_id(2, 1, $nx, $ny);
			my $posx = 2 * 0.05 * $nx + 0.1 - $Dx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;
			my %detector = init_det();

			$detector{"name"}        = "inclad_$id";
			$detector{"mother"}      = "lead_box" ;
			$detector{"description"} = "$nx $ny inclad b";
			$detector{"pos"}         = "$posx*cm $posy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "7CCBFF";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0.046*cm 0.048*cm $flength*cm 0*deg 360*deg";
			$detector{"material"}    = "inclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "inclad_b manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_outclad_b {
    for (my $nx=0; $nx<($ncols-1); $nx++) {
		for (my $ny=0; $ny<$nrowsb; $ny++) {
			my $id   = generate_id(3, 1, $nx, $ny);
			my $posx = 2 * 0.05 * $nx + 0.1 - $Dx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;
			my %detector = init_det();

			$detector{"name"}        = "outclad_$id";
			$detector{"mother"}      = "lead_box";
			$detector{"description"} = "$nx $ny outclad b";
			$detector{"pos"}         = "$posx*cm $posy*cm 0*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "0089E4";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0.048*cm 0.05*cm $flength*cm 0*deg 360*deg";
			$detector{"material"}    = "outclad";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "outclad_b manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_sensor_1b {
    for (my $nx=0; $nx<($ncols-1); $nx++) {
		for (my $ny=0; $ny<$nrowsb; $ny++) {
			my $id   = generate_id(4, 1, $nx, $ny);
			my %detector = init_det();

			$detector{"name"}        = "sensor_$id";
            $detector{"description"} = "$nx $ny sensor1 b";
            $detector{"mother"}      = "lead_box";
            my $posx = 2 * 0.05 * $nx + 0.1 - $Dx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;
            $detector{"pos"}         = "$posx*cm $posy*cm -1.99*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "339999";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0*cm 0.046*cm 0.01*cm 0*deg 360*deg";
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "sensor1_b manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
sub build_sensor_2b {
    for (my $nx=0; $nx<($ncols-1); $nx++) {
		for (my $ny=0; $ny<$nrowsb; $ny++) {
            my $id   = generate_id(5, 1, $nx, $ny);
			my %detector = init_det();

			$detector{"name"}        = "sensor_$id";
            $detector{"description"} = "$nx $ny sensor2 b";
            $detector{"mother"}      = "lead_box";
            my $posx = 2 * 0.05 * $nx + 0.1 - $Dx;
			my $posy = -$Dy + 0.05 + (0.05 * 1.732050808 + 0.05) * $ny * 2  + 0.05 * 1.732050808 + 0.05;
            $detector{"pos"}         = "$posx*cm $posy*cm 1.99*cm";
			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
			$detector{"color"}       = "339999";
			$detector{"type"}        = "Tube";
			$detector{"dimensions"}  = "0*cm 0.046*cm 0.01*cm 0*deg 360*deg";
			$detector{"material"}    = "core";
			$detector{"mfield"}      = "no";
			$detector{"style"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"sensitivity"} = "flux";
			$detector{"hit_type"}    = "flux";
			$detector{"identifiers"} = "sensor2_b manual $id";
			print_det(\%configuration, \%detector);
		}
    }
}
