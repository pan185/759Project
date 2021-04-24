#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 20
#SBATCH -J omp
#SBATCH -o jomp.out -e jomp.err
##SBATCH --open-mode=append

#./JacobiOMP 1024 testbenches/test_10.txt 0 0.0000000 test.txt $1
#./JacobiOMP 2048 testbenches/test_11.txt 0 0.0000000 test.txt $1
#./JacobiOMP 4096 testbenches/test_12.txt 0 0.0000000 test.txt $1
./JacobiOMP 8192 testbenches/test_13.txt 0 0.0000000 test.txt $1
