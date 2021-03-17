# BCAL
Small tool that builds GEMC volumes similar to the Babycal detector, then creates and runs
simulations based on these volumes.

## Usage
Run the `setup.sh` script to generate the materials and volumes needed for the simulation.

You can run the `.gcard` file yourself to visualize the generated detector and run a few simulations
by running:

```sh
cd gemc/
gemc bcal.gcard
```

To run a large amount of simulations in a finite amount of time, use the `run.sh` script.
The exported file should readable by
[gruid_translator](https://github.com/bleaktwig/gruid-translator) out-of-the-box.

## Structure
The source code is mainly structured in four files:
* `src/bcal.pl`: is the main script.
It calls all the other scripts for the whole simulation execution.
* `bcal_geometry.pl`: contains the geometry specifications of the different components of the
detector
* `bcal_materials.pl`: contains all the custom materials definitions.
* `bcal.gcard`: can be defined as an "initial input" script.
