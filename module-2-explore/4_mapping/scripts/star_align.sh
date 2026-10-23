#!/bin/zsh
#SBATCH -J alignJH
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -o output_%j.txt                   
#SBATCH -e error_%j.txt
#SBATCH --cpus-per-task=16
#SBATCH --mem=80G
#SBATCH --time=12:00:00

#Activate the STAR conda environment (two steps!)
module load anaconda3/2024.06
source /courses/BIOL2406.202710/shared/star_env

#Genome work root directory
ROOT_DIR="/courses/BIOL2406.202710/students/harel.z/inclass/genomes"

# Directory containing the genome index
GENOME_DIR="$ROOT_DIR/rnaseq/star_genome_dir"

# Directory containing the fastq files
FASTQ_DIR="$ROOT_DIR/rnaseq/fastq_files"

# Directory for the results
OUT_DIR="$ROOT_DIR/rnaseq/star_align_out"

# Create the output directory if it doesn't already exist
mkdir -p "$OUT_DIR"

# Loop through each read 1 file
for read1 in "$FASTQ_DIR"/*_1.fastq; do

    # Get the sample name by removing the directory and the _1.fastq ending
    sample=$(basename "$read1" _1.fastq)

    # The matching read 2 file
    read2="$FASTQ_DIR/${sample}_2.fastq"

    # Run STAR
    /courses/BIOL2406.202710/shared/star_env/bin/STAR --genomeDir "$GENOME_DIR" \
         --readFilesIn "$read1" "$read2" \
         --runThreadN 16 \
         --outFileNamePrefix "$OUT_DIR/${sample}_" \
         --outSAMtype BAM SortedByCoordinate \
         --limitBAMsortRAM 40000000000

done

