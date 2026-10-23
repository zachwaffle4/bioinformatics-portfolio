#!/bin/zsh
#SBATCH -J fasterqdump
#SBATCH -N 2
#SBATCH -n 16
#SBATCH -o output_%j.txt
#SBATCH -e error_%j.txt

# load sra module
module load sratoolkit/12Dec2024

# prefetch the file
prefetch --option-file SRR_Acc_List.txt

# run fasterq-dump command 
fasterq-dump --split-files SRR*/
