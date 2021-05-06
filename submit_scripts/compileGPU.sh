#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J cpu
#SBATCH -o compileGPU.out -e compileGPU.err
##SBATCH --open-mode=append

rm JacobiGPU
nvcc JacobiGPU.cu solve_jacobi.cu BasicSolver.cpp -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o JacobiGPU


