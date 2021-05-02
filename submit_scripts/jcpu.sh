#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J cpu
#SBATCH -o jcpu.out -e jcpu.err
##SBATCH --open-mode=append

./JacobiCPU $((2**$1)) testbenches/test_$1.txt 0 0.0000000 test.txt

