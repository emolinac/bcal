#!/bin/csh
# Set filename.
set nrows="7" # Set by hand based on bcal_geometry!
set ncols="7" # Set by hand based on bcal_geometry!
set FNAME="bcal_"`date +"%Y%m%d%H%M%S"`"_r"$nrows"c"$ncols".txt"

# Run gemc.
cd gemc/
gemc bcal.gcard
cd ../out/
mv "output.txt" $FNAME
