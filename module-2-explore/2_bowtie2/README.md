# Part 2: Bowtie2 on lambda phage

Covers `02_Explore/2_bowtie2_tutorial.md`: index the lambda phage genome, align the example reads (unpaired and
paired), then convert to BAM with samtools and call variants with bcftools. The working directory is on Explorer at
`/courses/BIOL2406.202710/students/harel.z/inclass/bowtie` (~18 MB).

## Layout

```
2_bowtie2/
├── README.md
├── bowtie2_session.txt        annotated session: commands and output
├── data/
│   ├── lambda_virus.fa        lambda phage genome, NC_001416.1 (48,502 bp)
│   ├── lambda_virus.fa.fai    faidx index of the genome
│   ├── reads_1.fq.gz          paired-end reads, mate 1 (10,000 reads, from the bowtie2 examples)
│   └── reads_2.fq.gz          mate 2
└── results/
    ├── eg1.sam.gz             reads_1.fq aligned as unpaired reads (-U)
    ├── eg2.sam.gz             reads_1.fq + reads_2.fq aligned as pairs (-1/-2)
    ├── eg2.bam                eg2.sam converted with samtools view
    ├── eg2.sorted.bam         eg2.bam sorted with samtools sort
    ├── eg2.raw.bcf            bcftools mpileup | bcftools call -mv output (binary BCF)
    └── variants.txt           bcftools view of eg2.raw.bcf: 90 called variants (VCF text)
```

The bowtie2 index (`lambda_virus.*.bt2`, 8 MB) is not stored here because it can be rebuilt from
`data/lambda_virus.fa` with `bowtie2-build lambda_virus.fa lambda_virus`. Large text files are gzipped
(`gunzip -k <file>.gz` to unpack); the BAMs are already compressed.

## Notes

The tutorial's `mpileup` command on its own writes one record per genome position, not variant calls. The saved
session shows both the tutorial's version and the second pass with `bcftools call -mv`; the files here are from the
second pass.
