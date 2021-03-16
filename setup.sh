#!/bin/csh
# Generate simulation
cd src/
perl bcal.pl config.dat
cd - > /dev/null

# Move output to gemc dir
mkdir -p gemc/
mv src/bcal__geometry_original.txt gemc/
mv src/bcal__materials_original.txt gemc/
