#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 20
#SBATCH -J run_all
#SBATCH --gres=gpu:1 
#SBATCH -o run_all.out -e run_all.err
##SBATCH --open-mode=append

rm -rf out
mkdir out

sbatch jcpu.sh

sbatch jomp.sh 12
#subtitute 12 with desirable number of threads

sbatch jgpu.sh 2 64
sbatch jgpu.sh 3 64

sbatch jthrust.sh


