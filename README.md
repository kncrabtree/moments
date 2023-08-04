# moments
Program for calculating rotational constants from an xyz molecular geometry.
Supports nonstandard isotopologues and will calculate internal rotation parameters for 1 methyl rotor.

### Installation and Requirements

The program is self-contained in a single script: `moments.py`. On Mac/Linux, you can make the script executable and place in a directory contained in your `PATH` environment variable. The program requires only Python3, numpy, scipy, matplotlib, and pandas.

### Usage - Quickstart

- Quick help
```moments.py -h```

- Basic usage, generates output files `examples/acetaldehyde.xyz-moments.csv` and `examples/acetaldehyde.xyz-coords.png`
  
```moments.py examples/acetaldehyde.xyz```

- Nonstandard isotopes (change atom 0 to $^{13}\text{C}$ and atom 2 to $^{18}\text{O}$)
  
```moments.py examples/acetaldehyde.xyz -i 0-13,2-18```

- Calculate PAM and RAM Hamiltonian terms (methyl atoms are 1, 4, 5, and 6)
  
```moments.py examples/acetaldehyde.xyz -m 1,4,5,6```

- As above, but suppress output printing and specify names of output files
  
```moments.py examples/acetaldehyde.xyz -m 1,4,5,6 -q -o output.csv -p coordinates.png```

- Do not generate plots
  
```moments.py examples/acetaldehyde.xyz -m 1,4,5,6 -q -o output.csv --no-plots```

### Usage - Details

From a command line, run the script and pass the name of a file containing the molecular geometry in xyz format. As an example:
```moments.py examples/acetaldyhyde.xyz```
The script will print information to standard output (see below for examples) and will generate 2 output files: a csv file containing the spectrosscopic constants and atomic masses, and an image file showing the molecular geometry in principal axis coordinates.

The input file should be in JMOLplot-like format. For example, the examples/acetaldehyde.txt file contains:
```
7

C	0.2318720	0.4020210	-0.0000010
C	-1.1692990	-0.1492850	-0.0000010
O	1.2348180	-0.2777630	0.0000010
H	0.3048290	1.5072150	-0.0000040
H	-1.1484750	-1.2375600	-0.0001760
H	-1.7051140	0.2178780	0.8795140
H	-1.7052250	0.2181590	-0.8793310
```
The first line is ignored. The second line may optionally contain the molecule's name, and the remaining lines contain the atoms and their coordinates. By default, the program assumes the coordinates are in units of Angstrom, but this can be modified by passing the `-b` or `--bohr` flag. Any whitespace characters may be used to separate the columns. Atom labels are case-sensitive. The script will remove any dummy atoms (indicated by `x` or `X`), but any ghost atoms will need to be removed manually.

By default, the program will use the mass corresponding to the most abundant isotopologue for the indicated atom. To use a different mass for an atom, there are two options. You may append the atomic mass number (as an integer) to the end of the respective line in the input file, or you may pass the desired mass numbers for particular atoms using the `-i`/`--isotopes` flag. Atoms are specified by their index, starting from 0, followed by a dash and finally the mass number. For example, to change the first carbon atom (0) to $^{13}\text{C}$, the oxygen (2) to $^{18}\text{O}$, and the last three hydrogens (4, 5, and 6) to D, call the script with
```moments.py examples/acetaldehyde.xyz -i 0-13,2-18,4-2,5-2,6-2```
or edit the input file as follows:
```
7

C	0.2318720	0.4020210	-0.0000010 13
C	-1.1692990	-0.1492850	-0.0000010
O	1.2348180	-0.2777630	0.0000010 18
H	0.3048290	1.5072150	-0.0000040
H	-1.1484750	-1.2375600	-0.0001760 2
H	-1.7051140	0.2178780	0.8795140 2
H	-1.7052250	0.2181590	-0.8793310 2
```

If the molecule contains a methyl group, the program can be used to additional compute internal rotation parameters relevant for the RAM Hamiltonian (e.g., $\rho$, $F$, $D_{ab}$, etc). To do so, use the `-m`/`--ch3`/`--methyl` flad and pass the indices of the methyl atoms in a comma-delimited list. For example,
```moments.py examples/acetaldehyde.xyz -m 1,4,5,6```
The list must contain exactly 4 atoms, and the atom numbering starts at 0. This may produce the following output:
```
./moments.py examples/acetaldehyde.xyz -m 1,4,5,6
Initial coordinates
Atom   Mass      X (A)       Y (A)       Z (A)
C     12.000000  0.23187200  0.40202100 -0.00000100
C     12.000000 -1.16929900 -0.14928500 -0.00000100
O     15.994915  1.23481800 -0.27776300  0.00000100
H      1.007825  0.30482900  1.50721500 -0.00000400
H      1.007825 -1.14847500 -1.23756000 -0.00017600
H      1.007825 -1.70511400  0.21787800  0.87951400
H      1.007825 -1.70522500  0.21815900 -0.87933100

Principal Axis Coordinates
Atom   Mass       a (A)       b (A)       c (A)
C     12.000000 -0.13614694 -0.41789221 -0.00000099
C     12.000000  1.26502406  0.13341379  0.00000007
O     15.994915 -1.13909294  0.26189179  0.00000025
H      1.007825 -0.20910394 -1.52308621 -0.00000403
H      1.007825  1.24420006  1.22168879 -0.00017496
H      1.007825  1.80083839 -0.23374920  0.87951547
H      1.007825  1.80095072 -0.23403022 -0.87932953

Principal Axis Rotational Constants
A   56847.1872 MHz
B   10126.3203 MHz
C    9076.5140 MHz
------------------------
A  1.896218057 cm-1
B  0.337777686 cm-1
C  0.302759918 cm-1

Inertial Defect: -3.117742846 amu A^2

CH3 atoms: [1 4 5 6]

CH3 Rotational Constants
A  267664.4874 MHz
B  257627.4898 MHz
C  158361.3753 MHz
------------------------
A  8.928326256 cm-1
B  8.593528052 cm-1
C  5.282366888 cm-1

I_alpha = 3.191302

CH3 Axis
lambda_a   -0.9302968
lambda_b   -0.3668076
lambda_c   -0.0000008

rho Axis
rho_a      -0.3339498
rho_b      -0.0234553
rho_c      -0.0000000
r           0.6807239

RAM Rotation Vector
Ra    0.0000000 rad
Rb    0.0000001 rad
Rc   -0.0700634 rad
------------------------
Ra      0.00000 deg
Rb      0.00001 deg
Rc     -4.01433 deg

Rho Axis System Parameters
rho        0.334772538
F          232636.7064 MHz
A_ram       56707.7165 MHz
B_ram       10101.4760 MHz
C_ram        9076.5140 MHz
D_ab        -3979.6467 MHz
D_bc           -0.0000 MHz
D_ac           -0.0074 MHz
------------------------
F          7.759925249 cm-1
A_ram      1.891565814 cm-1
B_ram      0.336948971 cm-1
C_ram      0.302759918 cm-1
D_ab      -0.132746727 cm-1
D_bc      -0.000000002 cm-1
D_ac      -0.000000247 cm-1
```
Along with the image:
![acetaldehyde xyz-coords](https://github.com/kncrabtree/moments/assets/20146313/dbcdabd1-8e6f-4125-b81e-a13e95c7192b)

and the following csv data:
```
param,value,unit
,examples/acetaldehyde.xyz,
A,56847.187226472546,MHz
B,10126.320275093807,MHz
C,9076.514014305507,MHz
A,1.896218057175826,cm-1
B,0.33777768602483677,cm-1
C,0.3027599184735163,cm-1
ID,-3.11774284610439,amu A^2
A (CH3),267664.48741650145,MHz
B (CH3),257627.4897580687,MHz
C (CH3),158361.3753446761,MHz
A (CH3),8.928326256176247,cm-1
B (CH3),8.593528051932136,cm-1
C (CH3),5.282366888118183,cm-1
I_alpha,3.1913022227893046,amu A^2
lambda_a,-0.9302968186550009,
lambda_b,-0.3668076187864764,
lambda_c,-7.614760184693406e-07,
rho_a,-0.3339498492682833,
rho_b,-0.023455286486947332,
rho_c,-4.364415084266244e-08,
r,0.680723939851134,
Ra,0.0,rad
Rb,1.3036956700683567e-07,rad
Rc,-0.0700633529186581,rad
Ra,0.0,deg
Rb,7.469625966439669e-06,deg
Rc,-4.014334420774707,deg
rho,0.3347725381367113,
F,232636.70641480276,MHz
A_ram,56707.71647091714,MHz
B_ram,10101.47602846236,MHz
C_ram,9076.51401430543,MHz
D_ab,-3979.6467450821065,MHz
D_bc,-4.6228642236308716e-05,MHz
D_ac,-0.0074050812783519,MHz
F,7.7599252485131816,cm-1
A_ram,1.891565813537482,cm-1
B_ram,0.33694897115998695,cm-1
C_ram,0.3027599184735138,cm-1
D_ab,-0.13274672657315836,cm-1
D_bc,-1.5420215219793394e-09,cm-1
D_ac,-2.4700692364822266e-07,cm-1
C0,12.0,amu
C1,12.0,amu
O2,15.99491461926,amu
H3,1.007825031898,amu
H4,1.007825031898,amu
H5,1.007825031898,amu
H6,1.007825031898,amu
```
