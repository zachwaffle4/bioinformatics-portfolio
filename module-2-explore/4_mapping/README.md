# Part 4: RNA-seq reads and STAR mapping

Covers `02_Explore/4_Mapping_tutorial.md`: download human RNA-seq reads (GEO GSE52778, 8 SRA runs), check their
quality, index the human genome with STAR, and align the reads. The data live on Explorer in
`/courses/BIOL2406.202710/students/harel.z/inclass/genomes/` (about 170 GB in total, far too big for git):

| Directory (under `genomes/`) | Contents | Size |
|---|---|---|
| `ref/`, `annotation/` | human primary assembly FASTA and Ensembl GTF | 3 GB each |
| `rnaseq/sra_files/` | the 8 `.sra` downloads | 17 GB |
| `rnaseq/fastq_files/` | 8 paired-end FASTQ pairs | 101 GB |
| `rnaseq/qc/` | FastQC reports | 3 MB |
| `rnaseq/star_genome_dir/` | STAR index of GRCh38 + GTF | 29 GB |
| `rnaseq/star_align_out/` | sorted BAMs, STAR logs, splice-junction tables | 19 GB |

```
4_mapping/
├── README.md
├── rnaseq_quality_notes.txt      impressions of the FastQC reports, and whether to trim
├── scripts/
│   ├── fasterq_dump.sh           SLURM script: prefetch + fasterq-dump of the SRR accessions
│   ├── star_index.sh             SLURM script: STAR genomeGenerate (human FASTA + GTF)
│   ├── star_align.sh             SLURM script: STAR alignment of all 8 samples
│   └── job_logs/                 SLURM output/error files from the index and alignment jobs
├── qc/
│   ├── SRR1039509_1_fastqc.html
│   ├── SRR1039509_2_fastqc.html
│   └── SRR1039516_1_fastqc.html
└── results/
    ├── star_mapping_summary.tsv  reads and mapping rates for all 8 samples
    └── star_logs/                STAR Log.final.out for each sample
```

## Results

All 8 samples aligned. 92.4 to 94.7 % of read pairs mapped uniquely (mean 93.9 %), 3.6 to 4.2 % mapped to multiple
loci, and 1.7 to 3.6 % were left unmapped as too short. See `results/star_mapping_summary.tsv`. These rates agree
with the quality check: reads that were never trimmed still map very well, so trimming was not needed.

## Notes

- `scripts/fasterq_dump.sh` is the conversion script as run; it reads `SRR_Acc_List.txt` and expects the `SRR*`
  directories in its working directory, and that list file is no longer on Explorer. The tutorial calls it
  `accessions.txt`.
- Both STAR job error logs contain `command not found: module`. The scripts are written for `zsh`, where the
  `module` command is not defined inside a batch job, so `module load anaconda3/2024.06` did nothing. STAR still ran,
  because the alignment script calls the STAR binary by its full path inside the course conda environment. The jobs
  finished successfully, and the output is not affected.
- `star_index.sh` has no `--genomeDir`, so STAR's default output location is `GenomeDir/`; the index on Explorer is in
  `star_genome_dir/`, so it was presumably renamed afterwards. Add `--genomeDir` to the script if it should
  reproduce the final layout.
- The STAR index and BAM files are far too big for git and stay on Explorer.
