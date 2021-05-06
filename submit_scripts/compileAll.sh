#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -J all
#SBATCH -o compileAll.out -e compileAll.err
##SBATCH --open-mode=append

sbatch submit_scripts/compileCPU.sh
sbatch submit_scripts/compileGPU.sh
sbatch submit_scripts/compileOMP.sh
sbatch submit_scripts/compileThrust.sh

