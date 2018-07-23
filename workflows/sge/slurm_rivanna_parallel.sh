#!/bin/bash
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=16
#SBATCH --time=12:00:00
#SBATCH --output=output_filename
#SBATCH --partition=parallel 
#SBATCH -A mygroup

module load gcc
module load openmpi

srun ./parallel_executable
