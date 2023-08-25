# vmdAssist
vmdAssist is a VMD extension with tools that help us edit or create new structures like nanotube and nanotorus.
You can use vmdAssist to convert any sheet structure to nanotube, nanotorus, spiral tube, or spiral sheet structure. vmdAssist has new options for changing the view direction or adding XYZ axes.


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


![vmdassist window 1](https://iili.io/HZ3o9mQ.png)
![vmdassist window 2](https://iili.io/HZ3np7j.png)
![vmdassist window 3](https://iili.io/HZ3nmdb.png)
![vmdassist nano structure example](https://iili.io/HZa8TPe.png)


------------------------------------------------------------------
## Getting Started
### Prerequisites:
vmdAssis is a VMD extension, therefore you must install VMD first.

### Installation:
#### method 1:
1) Place the "vmdassist1.0" folder in the VMD plugins directory:
   
   (windows) ```C:\Program Files (x86)\University of Illinois\VMD\plugins\noarch\tcl```
   
   (UNIX) ```/usr/local/lib/vmd/plugins/noarch/tcl```

![plugin](https://iili.io/HZ3nDru.png)

2)
  (windows) Add the following at the end of "vmd.rc" in "C:\Program Files (x86)\University of Illinois\VMD":
  
  ```vmd_install_extension vmdAssist vmdAssist_gui "vmdAssist"```
  
  (unix) Add the following at the end of ".vmdrc" in "/usr/local/lib/vmd":
  
  ```vmd_install_extension vmdAssist vmdAssist_gui "vmdAssist"```

![vmdrc](https://iili.io/HZ3dye1.png)

#### method 2:
Using Install.tcl file
1) Open VMD and then go to "Tk Console" (Extensions -> Tk Console)
2) Go to the vmdAssist folder on Tk Console:

    (windows)    ```cd {C:\Users\PcName\Desktop\vmdAssist-1.0.0}```

    (unix)    ```cd {/home/username/Desktop/vmdAssist-1.0.0}```

3) Enter the following command:
   
   ```source Install.tcl```

4) Restart VMD

------------------------------------------------------------------
## How to cite:
Please cite vmdAssist using

https://doi.org/10.5281/zenodo.8192857
[![DOI](https://zenodo.org/badge/671649701.svg)](https://zenodo.org/badge/latestdoi/671649701)


------------------------------------------------------------------
## Contact:
Nader Malih - Email: malih.nader@gmail.com

