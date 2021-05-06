#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 20
#SBATCH -J omp
#SBATCH -o jomp.out -e jomp.err
##SBATCH --open-mode=append

./JacobiOMP $((2**8)) testbenches/test_8.txt 0 0.0000000 test.txt $1 >> out/jomp_$1.out
./JacobiOMP $((2**9)) testbenches/test_9.txt 0 0.0000000 test.txt $1 >> out/jomp_$1.out
./JacobiOMP $((2**10)) testbenches/test_10.txt 0 0.0000000 test.txt $1 >> out/jomp_$1.out
./JacobiOMP $((2**11)) testbenches/test_11.txt 0 0.0000000 test.txt $1 >> out/jomp_$1.out
./JacobiOMP $((2**12)) testbenches/test_12.txt 0 0.0000000 test.txt $1 >> out/jomp_$1.out
./JacobiOMP $((2**13)) testbenches/test_13.txt 0 0.0000000 test.txt $1 >> out/jomp_$1.out
#./JacobiOMP 2048 testbenches/test_11.txt 0 0.0000000 test.txt $1
#./JacobiOMP 4096 testbenches/test_12.txt 0 0.0000000 test.txt $1
#./JacobiOMP 8192 testbenches/test_13.txt 0 0.0000000 test.txt $1

