#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J all
#SBATCH -o compileAll.out -e compileAll.err
##SBATCH --open-mode=append

sbatch compileCPU.sh
sbatch compileGPU.sh
sbatch compileOMP.sh
sbatch compileThrust.sh

