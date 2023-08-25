# moments
Program for calculating rotational constants from an xyz molecular geometry.
Supports nonstandard isotopologues and will calculate internal rotation parameters for 1 internal rotor.

[![DOI](https://zenodo.org/badge/674807150.svg)](https://zenodo.org/badge/latestdoi/674807150)

<p align="center">
  <img src="https://github.com/kncrabtree/moments/assets/20146313/338e14c3-1f8c-48c7-9d61-010cb9c6c4ed" width=400 align="center"/>
  <img src="https://github.com/kncrabtree/moments/assets/20146313/01777d01-63fa-4aaf-95ef-6b2ffb5ee255" width=400 align="center"/>
</p>

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

Computes rotational constants and optionally internal rotation constants from
xyz coordinates.

positional arguments:
  filename              Name of xyz file (JMOLplot format)

optional arguments:
  -h, --help            show this help message and exit
  -i ISOTOPES, --isotopes ISOTOPES
                        Use nonstandard isotopes. Specify as list of index-
                        massnumber (example: -i 0-18,1-2,2-2,3-13 for
                        ^18O,D,D,^13C, if those are the first 4 atoms in the
                        file). Alternatively, add the mass number to the end
                        of the respective line in the input file. Isotopes
                        specified on the command line will supersede those
                        specified in the input file. An atom may only appear
                        once (if the same atom is indicated multiple times,
                        only the last entry will be used).
  -t THRESHOLDSUBS, --threshold-subs THRESHOLDSUBS
                        Perform calculation for parent and every isotopologue
                        whose natural abundance is above the indicated
                        threshold. The threshold may be entered in either
                        floating point or scientific notation. Note that the
                        fractional abundance calculation is for the whole
                        molecule, not the individual nucleus. For instance,
                        for a hydrocarbon, a threshold of 0.01 will include
                        all single-13C substitutions, while for a Cl-
                        containing molecule it would not include any 13-C
                        substitutions owing to the abundances of the two
                        primary Cl isotopes. This mode implies --no-csv and
                        --no-plots; to override this behavior, provide the
                        --batch-folder option, and the results from each
                        calculation will be stored there. A single csv output
                        file will be generated (see --batch-outfile).
  -a AUTOSUBS, --auto-single-subs AUTOSUBS
                        Perform calculation for parent and all singly-
                        subsituted isotopologues involving the listed
                        elements (case sensitive). The substitution will be
                        the second-most naturally abundant isotopologue. This
                        mode implies --no-csv and --no-plots; to override
                        this behavior, provide the --batch-folder option, and
                        the results from each calculation will be stored
                        there. A single csv output file will be generated
                        (see --batch-outfile). For example, to generate all D
                        and ^13C singly-substituted isotopologues, use -a
                        H,C.
  -m MANUALSUBS, --manual-single-subs MANUALSUBS
                        Perform calculation for parent and the specified
                        single isotope substitutions. The format is the same
                        as for --isotopes, with the exception that the same
                        atom may apper multiple times. This mode implies
                        --no-csv and --no-plots; to override this behavior,
                        provide the --batch-folder option, and the results
                        from each calculation will be stored there. A single
                        csv output file will be generated (see --batch-
                        outfile). For example, assume atom 10 is S; to
                        compute the parent (32S) as well as 33S and 34S, use
                        -m 10-33,10-34.
  -e EXPLICITSUBS, --explicit-subs EXPLICITSUBS
                        Perform calculation for parent and the specified
                        substitutions. The format is similar to --isotopes,
                        with each set of substitutions separated by
                        semicolons. The list must be contained in quotes.
                        This mode implies --no-csv and --no-plots; to
                        override this behavior, provide the --batch-folder
                        option, and the results from each calculation will be
                        stored there. A single csv output file will be
                        generated (see --batch-outfile). For example, assume
                        atoms 1 and 3 are C and atom 2 is O. Passing -e
                        "1-13;3-13;1-13,3-13;2-18;1-13,2-18" would perform
                        the following sets of calculations: 12-16-12,
                        13-16-12, 13-16-13, 12-16-13, 12-18-12, and 13-18-12.
  -c COMBOSUBS, --combo-subs COMBOSUBS
                        Perform calculation for parent and every combination
                        of the indicated substitutions. The format is the
                        same as for --isotopes, with the exception that the
                        same atom may apper multiple times. This mode implies
                        --no-csv and --no-plots; to override this behavior,
                        provide the --batch-folder option, and the results
                        from each calculation will be stored there. A single
                        csv output file will be generated (see --batch-
                        outfile). For example, assume atom 0 is C, atom 1 is
                        D, and atom 2 is S. Passing -c 0-13,1-2,2-33,2-34
                        will perform the calculations 12-1-32, 13-1-32,
                        12-2-32, 12-1-33, 12-1-34, 13-2-32, 13-1-33, 13-1-34,
                        13-2-33, and 13-2-34.

Input/output options:
  -b, --bohr            Atomic coordinates in the input file are in Bohr
  -q, --quiet           Do not print text; only write output files
  -3d, --3d-plots       Generate 3D plots instead of 2D. WARNING: 3D plotting
                        is very slow!
  -s, --no-plots        Do not generate atomic coordinate plots
  -d, --no-csv          Do not generate output csv file
  -n MOLNAME, --name MOLNAME
                        Molecule name (optional, if omitted it is read from
                        line 2 of the input file or the input filename)
  -r ROTOR_ATOMS, --rotor ROTOR_ATOMS
                        Indices of atoms in rotor. Atoms are indexed from 0.
                        (optional, example -r 0,2,3,4)
  -o OUTFILE, --outfile OUTFILE
                        Name of output file. If not specified, will use
                        {input_filebase}-moments.csv
  -p PLOTFILE, --plotfile PLOTFILE
                        Base filename for atomic coordindate plots. If not
                        specified, will use {input_filebase}-ab.png, etc
  -bo BOUTFILE, --batch-outfile BOUTFILE
                        Name of output file for a batch calculation. If not
                        specified, will use {input_filebase}-all.csv. This
                        argument has no effect if only a single isotopologue
                        is calculated
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

By default, the program will use the mass corresponding to the most abundant isotopologue for the indicated atom. To perform computations for other isotopologues, pass the desired mass numbers for particular atoms using the `-i`/`--isotopes` flag. Atoms are specified by their index, starting from 0, followed by a dash and finally the mass number. For example, to change the first carbon atom (0) to $^{13}\text{C}$, the oxygen (2) to $^{18}\text{O}$, and the last three hydrogens (4, 5, and 6) to D, call the script with
```moments.py examples/acetaldehyde/acetaldehyde.xyz -i 0-13,2-18,4-2,5-2,6-2```
Several batch modes are available for performing sets of substitutions at once; these are described in the help documentation above, and examples can be found in the [examples/acetaldehyde-subs](https://github.com/kncrabtree/moments/tree/main/examples/acetaldehyde-subs) and [examples/ocs](https://github.com/kncrabtree/moments/tree/main/examples/ocs) folders.

If the molecule contains an internal rotor, the program can be used to additional compute internal rotation parameters relevant for the RAM Hamiltonian (e.g., $\rho$, $F$, $D_{ab}$, etc) as used in [BELGI](http://info.ifpan.edu.pl/~kisiel/introt/introt.htm#belgi), [RAM36](http://info.ifpan.edu.pl/~kisiel/introt/introt.htm#ram36), and their variants, as well as the CAM Hamiltonian ($\epsilon$, $\delta$, etc) as used in [XIAM](http://info.ifpan.edu.pl/~kisiel/introt/introt.htm#xiam). To do so, use the `-r`/`--rotor` flag and pass the indices of the rotor in a comma-delimited list. For example,
```moments.py examples/acetaldehyde/acetaldehyde.xyz -r 1,4,5,6```
Note that the atom numbering starts at 0. For molecules which possess multiple rotors, the script can be run separately for each rotor. See [examples/ac-ala-ome](https://github.com/kncrabtree/moments/tree/main/examples/ac-ala-ome).

For additional use cases, see the [examples](https://github.com/kncrabtree/moments/tree/main/examples) folder.
