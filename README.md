![image](https://github.com/n-malih/vmdAssist/assets/131417595/828d5815-59b0-463e-8db0-e7100b0c425c)# vmdAssist
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

![win1](https://iili.io/HZ26O3x.png)
![win2](https://iili.io/HZ26eYQ.png)
![win3](https://iili.io/HZ26kvV.png)
![builder](https://iili.io/HZ26LaR.png)


------------------------------------------------------------------
## Getting Started
### Prerequisites:
vmdAssis is a VMD extension, therefore you must install VMD first.

### Usage:
1) Place "vmdassist1.0" folder in the VMD plugins directory:
  C:\Program Files (x86)\University of Illinois\VMD\plugins\noarch\tcl
  ![plugins](https://iili.io/HZ2LLiX.png)
2) Add the following to the end of "vmd.rc" in "C:\Program Files (x86)\University of Illinois\VMD":
   vmd_install_extension vmdAssist vmdAssist_gui "vmdAssist"
   ![vmdrc](https://iili.io/HZ3dye1.png)


------------------------------------------------------------------
## Contact:
Nader Malih - Email: malih.nader@gmail.com

