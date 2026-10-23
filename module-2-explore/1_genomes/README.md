# Part 1: Working with genome sequences

Covers `02_Explore/1_Genomes_tutorial.md`. The working directory lives on Explorer at
`/courses/BIOL2406.202710/students/harel.z/inclass/genomes` (~130 GB, far too big for git), so this folder holds the
small files and a map of where everything else is.

## Layout

```
1_genomes/
├── README.md              this file
├── Genomes_info.md        size / structure / gene count / access for each genome
├── infoseq_session.txt    infoseq commands, output, and answers to the four questions
└── data/
    ├── genomes/
    │   ├── B_burgdorferi_genomic.fna.gz  B. burgdorferi B31 (1 chromosome + 21 plasmids)
    │   └── lambda_virus.fa               lambda phage, NC_001416.1
    └── annotation/
        └── hACE2.gtf                     ACE2 subset of the Ensembl GRCh38 GTF
```

Large text files are gzipped (`gunzip -k <file>.gz` to unpack).

## Large files left on Explorer

Base path: `/courses/BIOL2406.202710/students/harel.z/inclass/`

| File | Size | Location |
|---|---|---|
| C. elegans genome `C_elegans_genomic.fna` | 97 MB | `genomes/ref/` |
| Human primary assembly `H_sapiens_primary_assembly.fa` | 3.0 GB | `genomes/ref/` |
| Human annotation `H_sapiens_GRCh38.gtf` | 3.1 GB | `genomes/annotation/` |
| Sea cucumber (`Sea_cuke`) | | `fastq_files/` |

Lambda phage reads are in `bowtie/` (see `../2_bowtie2/`). The RNA-seq data downloaded for part 4 is in
`genomes/rnaseq/`. On Explorer, `genomes/` is organized as `ref/` (FASTA), `annotation/` (GTF) and `rnaseq/`
(`sra_files/`, `fastq_files/`, `qc/`, `scripts/`).
