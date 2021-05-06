#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J cpu
#SBATCH -o compileThrust.out -e compileThrust.err
##SBATCH --open-mode=append

rm JacobiThrust
nvcc test_thrust.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o JacobiThrust

