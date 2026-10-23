#!/bin/zsh
#SBATCH -J indxJH
#SBATCH -N 2
#SBATCH -n 16
#SBATCH -o output_%j.txt
#SBATCH -e error_%j.txt
#SBATCH -t 24:00:00

#Activate the STAR conda environment (two steps!)
module load anaconda3/2024.06
source /courses/BIOL2406.202710/shared/star_env

#Genome work root directory
GENOME_DIR="/courses/BIOL2406.202710/students/harel.z/inclass/genomes"

#Run the indexing command (you'll need to customize this to reflect the names and locations of your files)
STAR --runMode genomeGenerate --genomeFastaFiles "${GENOME_DIR}/ref/H_sapiens_primary_assembly.fa" --sjdbGTFfile "${GENOME_DIR}/annotation/H_sapiens_GRCh38.gtf" --runThreadN 16
