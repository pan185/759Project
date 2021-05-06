#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J cpu
#SBATCH -o jcpu.out -e jcpu.err
#SBATCH --open-mode=append

./JacobiCPU $((2**8)) testbenches/test_8.txt 0 0.0000000 test.txt >> out/jcpu.out
./JacobiCPU $((2**9)) testbenches/test_9.txt 0 0.0000000 test.txt >> out/jcpu.out
./JacobiCPU $((2**10)) testbenches/test_10.txt 0 0.0000000 test.txt >> out/jcpu.out
./JacobiCPU $((2**11)) testbenches/test_11.txt 0 0.0000000 test.txt >> out/jcpu.out
./JacobiCPU $((2**12)) testbenches/test_12.txt 0 0.0000000 test.txt >> out/jcpu.out
./JacobiCPU $((2**13)) testbenches/test_13.txt 0 0.0000000 test.txt >> out/jcpu.out

