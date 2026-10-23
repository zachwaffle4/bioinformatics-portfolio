# Part 3: Genetic variants (sea cucumber)

Covers `02_Explore/3_Variants_tutorial.md`: QC with fastqc, adapter trimming with cutadapt, mapping with bowtie2,
SAM to BAM with samtools, and genotype likelihoods / SNP calling with ANGSD, on a subsample of the
*Parastichopus parvimensis* genome and reads from 6 individuals.

The working directory is on Explorer at `/courses/BIOL2406.202710/students/harel.z/inclass/variants` (SAM/BAM files,
bowtie2 index, trimmed reads). Only the session, answers and small results are kept here.

```
3_variants/
├── README.md
├── variants_session.txt              hash-commented session: commands plus output, cleaned up
├── variants_exercise_answers.txt     answers to the 3 in-class exercises
├── scripts/
│   └── run_variants_session.sh       the script that produced the session (run with srun -n 1 -c 4)
├── results/
│   ├── bam.filelist                  the 6 sorted BAMs passed to ANGSD
│   ├── genotype_likelihoods.mafs.gz  minor allele frequencies, SNP p-value 1e-2 (9 SNPs)
│   └── gl_p1e-1.mafs.gz              same with SNP p-value 1e-1 (54 SNPs)
└── qc/
    └── SRR6805880.tiny_fastqc.html   fastqc report for one of the six read files
```

## Headline results

- 6 read files x 1,000 reads (80 bp); every read starts with `TGCAG`
- Overall alignment rate ~21 % (expected to be low because the genome and reads were subsampled)
- ANGSD finds 9 SNPs at p < 1e-2, 54 at 1e-1, and none at 1e-4 or 1e-6

## Notes

- The 70 bp exercise used `cutadapt -g TGCAG -l 70`, so the reads are trimmed at the 5-prime end and then shortened
  to 70 bp.
