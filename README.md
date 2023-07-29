# vmdAssist
vmdAssist is a VMD extension with tools that help us edit or create new structures like nanotube and nano torus.


## Features:
- Change view direction
- Show Box button
- Show XYZ axes
- Create Nanotube, Nanotorus, Spiral tube, and Spiral sheet from any 2D sheet structure.
    + Sheet to Nanotube
    + Sheet to Nanotorus
    + Sheet to Spiral tube
    + Sheet to Spiral sheet
- Translating and rotating structure
- Calculating geometric center. move the geometric center to a specific location or center of the box
- Guess simulation box size
- Change atom attributes like name, type, mass, or charge
- Supercell builder
- Combine Structures
- Extract part of a structure
- LAMMPS data file Import/Export


![win1](https://iili.io/HZ3o9mQ.png)
![win2](https://iili.io/HZ3np7j.png)
![win3](https://iili.io/HZ3nmdb.png)
![builder](https://iili.io/HZ3odhB.png)


------------------------------------------------------------------
## Getting Started
### Prerequisites:
vmdAssis is a VMD extension, therefore you must install VMD first.

### Usage:
1) Place "vmdassist1.0" folder in the VMD plugins directory:

    (windows) > "C:\Program Files (x86)\University of Illinois\VMD\plugins\noarch\tcl"
   
    (unix)    > "/usr/local/lib/vmd/plugins/noarch/tcl"

![plugin](https://iili.io/HZ3nDru.png)


2)
    (windows) Add the following to the end of "vmd.rc" in "C:\Program Files (x86)\University of Illinois\VMD":

    vmd_install_extension vmdAssist vmdAssist_gui "vmdAssist"

![vmdrc](https://iili.io/HZ3dye1.png)

    (unix) Add the following to the end of ".vmdrc" in "/usr/local/lib/vmd":

    vmd_install_extension vmdAssist vmdAssist_gui "vmdAssist"

------------------------------------------------------------------
## How to cite:
Please cite vmdAssist using

https://doi.org/10.5281/zenodo.8192857
[![DOI](https://zenodo.org/badge/671649701.svg)](https://zenodo.org/badge/latestdoi/671649701)


------------------------------------------------------------------
## Contact:
Nader Malih - Email: malih.nader@gmail.com

