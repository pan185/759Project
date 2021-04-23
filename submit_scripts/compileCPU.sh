#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J cpu
#SBATCH -o compileCPU.out -e compileCPU.err
##SBATCH --open-mode=append

rm a.out
g++ JacobiCpu.cpp BasicSolver.cpp matrix.cpp matrix.h -Wall -O3 -std=c++17
