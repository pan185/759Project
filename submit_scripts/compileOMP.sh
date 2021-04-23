#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J omp
#SBATCH -o compileOMP.out -e compileOMP.err
##SBATCH --open-mode=append

rm JacobiOMP
g++ JacobiOMP.cpp BasicSolver.cpp matrix.cpp -Wall -O3 -std=c++17 -o JacobiOMP -fopenmp

