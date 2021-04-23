#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J cpu
#SBATCH -o jcpu.out -e jcpu.err
##SBATCH --open-mode=append

./a.out $((2**$1)) in.txt 0.0000002 test.txt

