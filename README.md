# moments
Program for calculating rotational constants from an xyz molecular geometry.
Supports nonstandard isotopologues and will calculate internal rotation parameters for 1 internal rotor.

[![DOI](https://zenodo.org/badge/674807150.svg)](https://zenodo.org/badge/latestdoi/674807150)

![ac-ala-ome-ab](https://github.com/kncrabtree/moments/assets/20146313/f628be54-197b-4968-a62a-86a826726806)

![ac-ala-ome-ab](https://github.com/kncrabtree/moments/assets/20146313/91a41a6d-8679-405a-b368-c57fda93f501)


### Installation and Requirements

The program is self-contained in a single script: `moments.py`. On Mac/Linux, you can make the script executable and place in a directory contained in your `PATH` environment variable. The program requires only Python3, numpy, scipy, matplotlib, and pandas. It can also be imported and used as part of a python script; see moments-example.ipynb.

### Usage - Quickstart

- Quick help
```moments.py -h```

- Basic usage
  
```moments.py examples/acetaldehyde/acetaldehyde.xyz```

- Nonstandard isotopes (change atom 0 to $^{13}\text{C}$ and atom 2 to $^{18}\text{O}$)
  
```moments.py examples/acetaldehyde/acetaldehyde.xyz -i 0-13,2-18```

- Compute parent and all singly-substituted $^{2}\text{H}$, $^{13}\text{C}$, and $^{18}\text{O}$ isotopologues

```moments.py examples/acetaldehyde-subs/acetaldehyde.xyz -a H,C,O```

- Compute all isotopologues with natural abundances greater than 1e-8:

```moments.py examples/ocs/ocs.xyz -t 1e-8```

- Calculate PAM and RAM Hamiltonian terms (methyl atoms are 1, 4, 5, and 6)
  
```moments.py examples/acetaldehyde/acetaldehyde.xyz -r 1,4,5,6```

- As above, but suppress output printing and specify names of output files
  
```moments.py examples/acetaldehyde/acetaldehyde.xyz -r 1,4,5,6 -q -o output.csv -p coordinates.png```

- Do not generate plots
  
```moments.py examples/acetaldehyde/acetaldehyde.xyz -r 1,4,5,6 -q -o output.csv --no-plots```

### Batch Mode

By using one of the options `-t`, `-a`, `-m`, `-e`, or `-c`, the program will run in a batch mode, performing the calculation for the parent and all selected isotopologues at once. By default, this mode does not generate plots or individual csv output files; instead, the spectroscopic parameters for all isotopologues are printed in one common csv file. The individual output files and/or plots may be generated using the `-bf` flag, in which the desired output directory should be provided. It will be created if it does not exist. Example commands and outputs are shown in the `examples/aceteldehyde-subs/` and `examples/ocs/` folders.

The modes provided are:
- `-t/--threshold-subs`: Perform calculations for all isotopologues with natural abundances greater than a given fractional abundance threshold.
- `-a/--auto-subs`: Perform single isotopic subsitutions for all atoms of the elements listed, using the second most common isotope for each element.
- `-m/--manual-subs`: Perform single isotopic substitutions for each listed atom (by index) and mass number.
- `-e/--explicit-subs`: Perform arbitrary isotopic substitutions as provided in a list (which must be enclosed in quotes).
- `-c/--combo-subs`: Perform calculations for every possible combination of the listed subsitutions by index and mass number.

See below for further details about these options.

### Usage - Details

```
usage: Moments Calculator [-h] [-b] [-q] [-3d] [-s] [-d] [-n MOLNAME]
                          [-r ROTOR_ATOMS] [-o OUTFILE] [-p PLOTFILE]
                          [-bo BOUTFILE] [-bf BOUTFOLDER]
                          [-i ISOTOPES | -t THRESHOLDSUBS | -a AUTOSUBS | -m MANUALSUBS | -e EXPLICITSUBS | -c COMBOSUBS]
                          filename

Computes rotational constants and optionally internal rotation constants
from xyz coordinates.

positional arguments:
  filename              Name of xyz file (JMOLplot format)

optional arguments:
  -h, --help            show this help message and exit
  -i ISOTOPES, --isotopes ISOTOPES
                        Use nonstandard isotopes. Specify as list of index-
                        massnumber (example: -i 0-18,1-2,2-2,3-13 for
                        ^18O,D,D,^13C, if those are the first 4 atoms in
                        the file). Alternatively, add the mass number to
                        the end of the respective line in the input file.
                        Isotopes specified on the command line will
                        supersede those specified in the input file. An
                        atom may only appear once (if the same atom is
                        indicated multiple times, only the last entry will
                        be used).
  -t THRESHOLDSUBS, --threshold-subs THRESHOLDSUBS
                        Perform calculation for parent and every
                        isotopologue whose natural abundance is above the
                        indicated threshold. The threshold may be entered
                        in either floating point or scientific notation.
                        Note that the fractional abundance calculation is
                        for the whole molecule, not the individual nucleus.
                        For instance, for a hydrocarbon, a threshold of
                        0.01 will include all single-13C substitutions,
                        while for a Cl-containing molecule it would not
                        include any 13-C substitutions owing to the
                        abundances of the two primary Cl isotopes. This
                        mode implies --no-csv and --no-plots; to override
                        this behavior, provide the --batch-folder option,
                        and the results from each calculation will be
                        stored there. A single csv output file will be
                        generated (see --batch-outfile).
  -a AUTOSUBS, --auto-single-subs AUTOSUBS
                        Perform calculation for parent and all singly-
                        subsituted isotopologues involving the listed
                        elements (case sensitive). The substitution will be
                        the second-most naturally abundant isotopologue.
                        This mode implies --no-csv and --no-plots; to
                        override this behavior, provide the --batch-folder
                        option, and the results from each calculation will
                        be stored there. A single csv output file will be
                        generated (see --batch-outfile). For example, to
                        generate all D and ^13C singly-substituted
                        isotopologues, use -a H,C.
  -m MANUALSUBS, --manual-single-subs MANUALSUBS
                        Perform calculation for parent and the specified
                        single isotope substitutions. The format is the
                        same as for --isotopes, with the exception that the
                        same atom may apper multiple times. This mode
                        implies --no-csv and --no-plots; to override this
                        behavior, provide the --batch-folder option, and
                        the results from each calculation will be stored
                        there. A single csv output file will be generated
                        (see --batch-outfile). For example, assume atom 10
                        is S; to compute the parent (32S) as well as 33S
                        and 34S, use -m 10-33,10-34.
  -e EXPLICITSUBS, --explicit-subs EXPLICITSUBS
                        Perform calculation for parent and the specified
                        substitutions. The format is similar to --isotopes,
                        with each set of substitutions separated by
                        semicolons. The list must be contained in quotes.
                        This mode implies --no-csv and --no-plots; to
                        override this behavior, provide the --batch-folder
                        option, and the results from each calculation will
                        be stored there. A single csv output file will be
                        generated (see --batch-outfile). For example,
                        assume atoms 1 and 3 are C and atom 2 is O. Passing
                        -e "1-13;3-13;1-13,3-13;2-18;1-13,2-18" would
                        perform the following sets of calculations:
                        12-16-12, 13-16-12, 13-16-13, 12-16-13, 12-18-12,
                        and 13-18-12.
  -c COMBOSUBS, --combo-subs COMBOSUBS
                        Perform calculation for parent and every
                        combination of the indicated substitutions. The
                        format is the same as for --isotopes, with the
                        exception that the same atom may apper multiple
                        times. This mode implies --no-csv and --no-plots;
                        to override this behavior, provide the --batch-
                        folder option, and the results from each
                        calculation will be stored there. A single csv
                        output file will be generated (see --batch-
                        outfile). For example, assume atom 0 is C, atom 1
                        is D, and atom 2 is S. Passing -c
                        0-13,1-2,2-33,2-34 will perform the calculations
                        12-1-32, 13-1-32, 12-2-32, 12-1-33, 12-1-34,
                        13-2-32, 13-1-33, 13-1-34, 13-2-33, and 13-2-34.

Input/output options:
  -b, --bohr            Atomic coordinates in the input file are in Bohr
  -q, --quiet           Do not print text; only write output files
  -3d, --3d-plots       Generate 3D plots instead of 2D
  -s, --no-plots        Do not generate atomic coordinate plots
  -d, --no-csv          Do not generate output csv file
  -n MOLNAME, --name MOLNAME
                        Molecule name (optional, if omitted it is read from
                        line 2 of the input file or the input filename)
  -r ROTOR_ATOMS, --rotor ROTOR_ATOMS
                        Indices of atoms in rotor. Atoms are indexed from
                        0. (optional, example -r 0,2,3,4)
  -o OUTFILE, --outfile OUTFILE
                        Name of output file. If not specified, will use
                        {input_filebase}-moments.csv
  -p PLOTFILE, --plotfile PLOTFILE
                        Base filename for atomic coordindate plots. If not
                        specified, will use {input_filebase}-ab.png, etc
  -bo BOUTFILE, --batch-outfile BOUTFILE
                        Name of output file for a batch calculation. If not
                        specified, will use {input_filebase}-all.csv. This
                        argument has no effect if only a single
                        isotopologue is calculated
  -bf BOUTFOLDER, --batch-folder BOUTFOLDER
                        If provided, output files for each individual
                        calculation in a batch will be generated and stored
                        in the indidated folder. The folder will be created
                        if it does not exist
```


From a command line, run the script and pass the name of a file containing the molecular geometry in xyz format. As an example:
```moments.py examples/acetaldehyde/acetaldyhyde.xyz```
The script will print information to standard output (see below for examples) and will generate 2 output files: a csv file containing the spectrosscopic constants and atomic masses, and an image file showing the molecular geometry in principal axis coordinates.

The input file should be in JMOLplot-like format. For example, the examples/acetaldehyde/acetaldehyde.txt file contains:
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
```moments.py examples/acetaldehyde/acetaldehyde.xyz -i 0-13,2-18,4-2,5-2,6-2```
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

If the molecule contains an internal rotor, the program can be used to additional compute internal rotation parameters relevant for the RAM Hamiltonian (e.g., $\rho$, $F$, $D_{ab}$, etc). To do so, use the `-r`/`--rotor` flag and pass the indices of the rotor in a comma-delimited list. For example,
```moments.py examples/acetaldehyde/acetaldehyde.xyz -r 1,4,5,6```
The list must contain exactly 4 atoms, and the atom numbering starts at 0. This may produce the following output:
```
Initial coordinates
Atom   Mass        X (A)         Y (A)         Z (A)
C     12.000000    0.13614694    0.41789221   -0.00000089
C     12.000000   -1.26502406   -0.13341379   -0.00000089
O     15.994915    1.13909294   -0.26189179    0.00000111
H      1.007825    0.20910394    1.52308621   -0.00000389
H      1.007825   -1.24420006   -1.22168879   -0.00017589
H      1.007825   -1.80083906    0.23374921    0.87951411
H      1.007825   -1.80095006    0.23403021   -0.87933089

Principal Axis Coordinates
Atom   Mass        a (A)         b (A)         c (A)
C     12.000000   -0.12530134    0.42127125   -0.00000075
C     12.000000    1.26115353   -0.16606288   -0.00000048
O     15.994915   -1.14548087   -0.23236526    0.00000057
H      1.007825   -0.16967101    1.52798162   -0.00000329
H      1.007825    1.21221079   -1.25343619   -0.00017596
H      1.007825    1.80627829    0.18712934    0.87951489
H      1.007825    1.80639719    0.18740814   -0.87933011

Interatomic Distance Matrix (A)

        C0     C1     O2     H3     H4     H5     H6   
C0     0.000  1.506  1.212  1.108  2.143  2.135  2.135
C1     1.506  0.000  2.408  2.217  1.088  1.093  1.093
O2     1.212  2.408  0.000  2.013  2.569  3.108  3.109
H3     1.108  2.217  2.013  0.000  3.106  2.545  2.545
H4     2.143  1.088  2.569  3.106  0.000  1.789  1.789
H5     2.135  1.093  3.108  2.545  1.789  0.000  1.759
H6     2.135  1.093  3.109  2.545  1.789  1.759  0.000

Principal Axis Rotational Constants
A        56847.1872 MHz
B        10126.3203 MHz
C         9076.5140 MHz
------------------------
A       1.896218057 cm-1
B       0.337777686 cm-1
C       0.302759918 cm-1

Second moments and Inertial Defect
Paa       48.348596977 amu A^2
Pbb        7.331260768 amu A^2
Pcc        1.558871423 amu A^2
Delta     -3.117742846 amu A^2

Rotor atoms: [1 4 5 6]

Rotor Rotational Constants
A  267664.4874 MHz
B  257627.4898 MHz
C  158361.3753 MHz
------------------------
A  8.928326256 cm-1
B  8.593528052 cm-1
C  5.282366888 cm-1

I_alpha = 3.191302

Rotor Axis
lambda_a   -0.9205062
lambda_b    0.3907280
lambda_c   -0.0000002

Rotor Axis angle with respect to principal axes
theta_a     0.3907280 rad
theta_b     0.9205062 rad
theta_c     1.0000000 rad
------------------------
theta_a      22.38706 deg
theta_b      52.74112 deg
theta_c      57.29578 deg

rho Axis
rho_a      -0.3304353
rho_b       0.0249849
rho_c      -0.0000000
r           0.6860700

RAM Rotation Vector
Ra   -0.0000000 rad
Rb    0.0000000 rad
Rc    0.0753967 rad
------------------------
Ra     -0.00000 deg
Rb      0.00000 deg
Rc      4.31991 deg

Rho Axis System Parameters
rho        0.331378528
F          230823.9398 MHz
A_ram       56685.6851 MHz
B_ram       10097.5515 MHz
C_ram        9076.5140 MHz
D_ab         4282.0325 MHz
D_bc            0.0000 MHz
D_ac           -0.0024 MHz
------------------------
F          7.699457864 cm-1
A_ram      1.890830926 cm-1
B_ram      0.336818064 cm-1
C_ram      0.302759918 cm-1
D_ab       0.142833228 cm-1
D_bc       0.000000001 cm-1
D_ac      -0.000000081 cm-1
```
Along with the images:
![acetaldehyde-ab](https://github.com/kncrabtree/moments/assets/20146313/e56e6e17-7ec7-47a0-9b27-fb1585d970bc)
![acetaldehyde-ac](https://github.com/kncrabtree/moments/assets/20146313/cb9a4b71-0f48-4a71-8d71-806f74f434e0)
![acetaldehyde-bc](https://github.com/kncrabtree/moments/assets/20146313/26c1115d-d6c2-4734-9ba8-0445a1d4bbe4)


and the following csv data:
```
param,value,unit,comment
,acetaldehyde.xyz,,
A,56847.187226472546,MHz,PAM Rotational Constant
B,10126.320275093807,MHz,PAM Rotational Constant
C,9076.514014305507,MHz,PAM Rotational Constant
A,1.896218057175826,cm-1,PAM Rotational Constant
B,0.33777768602483677,cm-1,PAM Rotational Constant
C,0.3027599184735163,cm-1,PAM Rotational Constant
Paa,48.348596977334196,amu A^2,PAM Second Moment
Pbb,7.33126076815131,amu A^2,PAM Second Moment
Pcc,1.5588714230521958,amu A^2,PAM Second Moment
Delta,-3.11774284610439,amu A^2,PAM Intertial Defect
Rotor,[1 4 5 6],,Atoms in rotor
A (rotor),267664.4874165015,MHz,Rotational Constant of Rotor Atoms
B (rotor),257627.48975806867,MHz,Rotational Constant of Rotor Atoms
C (rotor),158361.37534467614,MHz,Rotational Constant of Rotor Atoms
A (rotor),8.928326256176248,cm-1,Rotational Constant of Rotor Atoms
B (rotor),8.593528051932136,cm-1,Rotational Constant of Rotor Atoms
C (rotor),5.282366888118184,cm-1,Rotational Constant of Rotor Atoms
I_alpha,3.191302222789304,amu A^2,Rotor Moment of Inertia
lambda_a,-0.9205061977077206,,Direction Cosine of Rotor
lambda_b,0.39072796160706763,,Direction Cosine of Rotor
lambda_c,-2.4654801908661045e-07,,Direction Cosine of Rotor
rho_a,-0.3304352974349079,,Component of rho Axis
rho_b,0.024984858025235254,,Component of rho Axis
rho_c,-1.4130949201270074e-08,,Component of rho Axis
r,0.6860699781225276,,r Parameter for F Calculation
rho_Ra,-0.0,rad,Rotation Angle for PAM-RAM Transformation
rho_Rb,4.264292342655292e-08,rad,Rotation Angle for PAM-RAM Transformation
rho_Rc,0.07539673184145645,rad,Rotation Angle for PAM-RAM Transformation
rho_Ra,-0.0,deg,Rotation Angle for PAM-RAM Transformation
rho_Rb,2.4432595384410292e-06,deg,Rotation Angle for PAM-RAM Transformation
rho_Rc,4.319914523595083,deg,Rotation Angle for PAM-RAM Transformation
theta_a,0.3907279616071454,rad,Total Rotaton Angle between Rotor and Principal Axis
theta_b,0.9205061977077537,rad,Total Rotaton Angle between Rotor and Principal Axis
theta_c,0.9999999999999697,rad,Total Rotaton Angle between Rotor and Principal Axis
theta_a,22.387063137839096,deg,Total Rotaton Angle between Rotor and Principal Axis
theta_b,52.74112014428922,deg,Total Rotaton Angle between Rotor and Principal Axis
theta_c,57.29577951308059,deg,Total Rotaton Angle between Rotor and Principal Axis
rho,0.3313785281538884,,Magnitude of rho Vector
F,230823.93982322578,MHz,Torsion-Rotational Constant
A_ram,56685.68508584902,MHz,RAM Rotational Constant
B_ram,10097.55152714237,MHz,RAM Rotational Constant
C_ram,9076.5140143055,MHz,RAM Rotational Constant
D_ab,4282.032450784462,MHz,RAM Off-Diagonal Rotational Constant
D_bc,1.6271043664738374e-05,MHz,RAM Off-Diagonal Rotational Constant
D_ac,-0.002421834175687916,MHz,RAM Off-Diagonal Rotational Constant
F,7.6994578637207,cm-1,Torsion-Rotational Constant
A_ram,1.890830925634861,cm-1,RAM Rotational Constant
B_ram,0.3368180638867963,cm-1,RAM Rotational Constant
C_ram,0.3027599184735161,cm-1,RAM Rotational Constant
D_ab,0.14283322800550444,cm-1,RAM Off-Diagonal Rotational Constant
D_bc,5.427435957958079e-10,cm-1,RAM Off-Diagonal Rotational Constant
D_ac,-8.07836925533302e-08,cm-1,RAM Off-Diagonal Rotational Constant
C0,12.0,amu,"-0.12530134,0.42127125,-0.00000075"
C1,12.0,amu,"1.26115353,-0.16606288,-0.00000048"
O2,15.99491461926,amu,"-1.14548087,-0.23236526,0.00000057"
H3,1.007825031898,amu,"-0.16967101,1.52798162,-0.00000329"
H4,1.007825031898,amu,"1.21221079,-1.25343619,-0.00017596"
H5,1.007825031898,amu,"1.80627829,0.18712934,0.87951489"
H6,1.007825031898,amu,"1.80639719,0.18740814,-0.87933011"
```
