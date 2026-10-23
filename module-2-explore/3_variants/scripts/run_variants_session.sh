#!/bin/bash
# Runs 02_Explore/3_Variants_tutorial.md end to end, printing "# comment" and "$ command" lines
# followed by the real output, so the log reads as a saved session.
# Run on a compute node:  srun -n 4 --mem=8G -t 60 bash run_variants_session.sh 2>&1 | tee variants_session_raw.log

source /etc/profile 2>/dev/null

BASE=/courses/BIOL2406.202710/students/harel.z/inclass/variants
DATA=/courses/BIOL2406.202710/data/Sea_cuke

h() { echo; echo "# $*"; }
c() { echo "\$ $*"; eval "$*"; }

mkdir -p "$BASE" && cd "$BASE" || exit 1

h "Copy the Sea_cuke course data (1 genome, 6 fastq.gz) into my own directory and unzip it"
c 'cp /courses/BIOL2406.202710/data/Sea_cuke/* .'
c 'gunzip *.gz'
c 'ls'

h "Header line of the genome sequences (first few)"
c 'grep ">" Ppar_tinygenome.fna | head -5'
c 'grep -c ">" Ppar_tinygenome.fna'

h "What the read files look like (first two reads of one file)"
c 'head -8 SRR6805880.tiny.fastq'

h "Number of reads per fastq file (4 lines per read)"
c 'for f in *.fastq; do echo "$f $(( $(wc -l < $f) / 4 ))"; done'

h "Raw read quality control with fastqc: one file first"
c 'module load fastqc'
c 'fastqc SRR6805880.tiny.fastq'
c 'ls'

h "fastqc on the remaining files"
c 'fastqc SRR680588[1-5].tiny.fastq'
c 'ls *fastqc*'

h "Do the reads start with the same bases? Count reads beginning with TGCAG (the adapter remnant) in one file"
c 'grep -c "^TGCAG" SRR6805880.tiny.fastq'
c 'head -2 SRR6805880.tiny.fastq'

h "Activate cutadapt and trim the 5-prime TGCAG from one file"
c 'module load anaconda3/2024.06'
c 'source activate /courses/BIOL2406.202710/shared/cutadapt_env'
c 'cutadapt -g TGCAG SRR6805880.tiny.fastq -o SRR6805880.tiny_trimmed.fastq'

h "Trim all the read files with a for loop"
c 'for filename in *.tiny.fastq
do
  base=$(basename $filename .tiny.fastq)
  echo ${base}
  cutadapt -g TGCAG ${base}.tiny.fastq -o ${base}.tiny_trimmed.fastq
done'
c 'ls *trimmed*'

h "Check that trimmed reads no longer all start with TGCAG"
c 'grep -c "^TGCAG" SRR6805880.tiny_trimmed.fastq'

h "Leave the cutadapt environment before using angsd"
c 'conda deactivate'

h "Index the genome with bowtie2-build, then move the six .bt2 files into index/"
c 'module load bowtie2'
c 'bowtie2-build Ppar_tinygenome.fna Ppar_tinygenome > bowtie2-build.log 2>&1; tail -3 bowtie2-build.log'
c 'mkdir index'
c 'mv Ppar_tinygenome*.bt2 index/'
c 'ls index'

h "Map the trimmed reads to the genome (single-end), printing the alignment summary for each file"
c 'for filename in *.tiny_trimmed.fastq
do
  base=$(basename $filename .tiny_trimmed.fastq)
  echo ${base}
  bowtie2 -x index/Ppar_tinygenome -U ${base}.tiny_trimmed.fastq -S ${base}.sam
done'

h "Peek at one SAM file: header lines (@) then alignments"
c 'head -3 SRR6805880.sam | cut -c1-150'
c 'grep -v "^@" SRR6805880.sam | head -3 | cut -c1-150'

h "Convert each SAM to a sorted BAM with samtools"
c 'module load samtools'
c 'for filename in *.sam
do
  base=$(basename $filename .sam)
  echo ${base}
  samtools view -bhS ${base}.sam | samtools sort -o ${base}.bam
done'
c 'ls *.bam'

h "angsd needs a text file listing the bam files"
c 'ls *.bam > bam.filelist'
c 'cat bam.filelist'

h "Activate angsd and compute genotype likelihoods, calling SNPs at p < 1e-2"
c 'source activate /courses/BIOL2406.202710/shared/angsd_env'
c 'angsd -bam bam.filelist -GL 1 -out genotype_likelihoods -doMaf 2 -SNP_pval 1e-2 -doMajorMinor 1'
c 'ls genotype_likelihoods*'

h "Look at the minor allele frequency file and count the SNPs it contains (lines minus the header)"
c 'zcat genotype_likelihoods.mafs.gz | head -5'
c 'echo "SNPs at p<1e-2: $(( $(zcat genotype_likelihoods.mafs.gz | wc -l) - 1 ))"'

# ---------------------------------------------------------------------------
# In-class exercises
# ---------------------------------------------------------------------------
echo; echo "# ===== EXERCISE 1: map the untrimmed reads and compare alignment rates ====="
c 'conda deactivate'
c 'module load bowtie2'
c 'mkdir -p ex1_untrimmed'
c 'for filename in *.tiny.fastq
do
  base=$(basename $filename .tiny.fastq)
  echo ${base}
  bowtie2 -x index/Ppar_tinygenome -U ${base}.tiny.fastq -S ex1_untrimmed/${base}.sam
done'

echo; echo "# ===== EXERCISE 2: trim to 70 bp (after removing the adapter) and map ====="
c 'source activate /courses/BIOL2406.202710/shared/cutadapt_env'
c 'mkdir -p ex2_trim70'
c 'for filename in *.tiny.fastq
do
  base=$(basename $filename .tiny.fastq)
  echo ${base}
  cutadapt -g TGCAG -l 70 ${base}.tiny.fastq -o ex2_trim70/${base}.tiny_trimmed70.fastq
done'
c 'conda deactivate'
c 'for filename in ex2_trim70/*.fastq
do
  base=$(basename $filename .tiny_trimmed70.fastq)
  echo ${base}
  bowtie2 -x index/Ppar_tinygenome -U ex2_trim70/${base}.tiny_trimmed70.fastq -S ex2_trim70/${base}.sam
done'

echo; echo "# ===== EXERCISE 3: vary the angsd SNP p-value ====="
c 'module load samtools'
c 'source activate /courses/BIOL2406.202710/shared/angsd_env'
c 'for p in 1e-1 1e-4 1e-6
do
  angsd -bam bam.filelist -GL 1 -out gl_p${p} -doMaf 2 -SNP_pval ${p} -doMajorMinor 1 > /dev/null 2>&1
  echo "p=${p}: $(( $(zcat gl_p${p}.mafs.gz | wc -l) - 1 )) SNPs"
done'
echo "p=1e-2 (original): $(( $(zcat genotype_likelihoods.mafs.gz | wc -l) - 1 )) SNPs"
echo; echo "# DONE"
