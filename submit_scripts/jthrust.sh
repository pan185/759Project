#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 20
#SBATCH -J thrust
#SBATCH --gres=gpu:1 
#SBATCH -o jthrust.out -e jthrust.err
##SBATCH --open-mode=append

#./test_thrust 4 testbenches/test_4.txt test.txt >> out/jth.out
#cuda-memcheck ./test_thrust 6 testbenches/test_6.txt test.txt >> out/jth.out
./JacobiThrust $((2**8)) testbenches/test_8.txt test.txt >> out/jth.out
./JacobiThrust $((2**9)) testbenches/test_9.txt test.txt >> out/jth.out
./JacobiThrust $((2**10)) testbenches/test_10.txt test.txt >> out/jth.out
./JacobiThrust $((2**11)) testbenches/test_11.txt test.txt >> out/jth.out 
./JacobiThrust $((2**12)) testbenches/test_12.txt test.txt >> out/jth.out
./JacobiThrust $((2**13)) testbenches/test_13.txt test.txt >> out/jth.out

