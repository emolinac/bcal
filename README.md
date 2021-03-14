# bcal

GEMC functioning is pretty straight forward. First execute:
 
  gemc bcal.pl config.dat
  
Then execute the following line to obtain the simul results:

  ./bcal.pl bcal.gcard

In general terms:

-bcal.pl: is the main script. It calls all the other scripts for the whole simul execution

-bcal_geometry.pl: contains the geometry specifications of the different components of the detector

-bcal_materials.pl: contains custom materials definitions

-bcal.gcard: can be defined as an "initial input" script
