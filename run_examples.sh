#!/bin/bash

declare -a darray=("acetaldehyde" "acetaldehyde-3d" "acetaldehyde-subs" "cl-succinimide" "ocs")
declare -a farray=("acetaldehyde" "acetaldehyde" "acetaldehyde" "cl-succinimide" "ocs")
declare -a argsarray=("-r 1,4,5,6" "-r 1,4,5,6 -3d" "-r 1,4,5,6 -a C,H,O -bf outputs -s" "" "-t 1e-8")

declare -a acarrd=("ac-ala-ome" "ac-ala-ome-3d")
declare -a acarra=("-r 0,1,2,3" "-r 13,14,15,16" "-r 17,18,19,20")
declare -a acarra2=("" "-3d")
declare -a acarra3=("r0123" "r13141516" "r17181920")
based=$(pwd)

num1=${#darray[@]}
num2=${#acarrd[@]}
num3=${#acarra[@]}
num=$((num1 + num2*num3))
for (( i=0; i<${num1}; i++ ));
do
    d="${darray[$i]}"
    f="${farray[$i]}"
    a="${argsarray[$i]}"
    echo "Running examples/$d ($((i+1))/$num)"
    cd examples/$d
    echo "Command: moments.py $f.xyz $a > $f-output.txt" > $f-output.txt
    echo "" >> $f-output.txt
    moments $f.xyz $a >> $f-output.txt
    cd $based
done

for (( i=0; i<${num2}; i++ ));
do
    d="${acarrd[$i]}"
    for (( j=0; j<${num3}; j++ ));
    do
        a="${acarra[$j]} ${acarra2[$i]}"
        t="${acarra3[$j]}"
        echo "Running examples/$d $t ($((num1 + i*num3 + j + 1))/$num)"
        cd examples/$d
        echo "Command: moments.py ac-ala-ome.xyz $a -o ac-ala-ome-$t-moments.csv -p ac-ala-ome-$t > ac-ala-ome-$t-output.txt" > ac-ala-ome-$t-output.txt
        echo "" >> ac-ala-ome-$t-output.txt
        moments ac-ala-ome.xyz $a -o ac-ala-ome-$t-moments.csv -p ac-ala-ome-$t >> ac-ala-ome-$t-output.txt
        cd $based
    done
done

