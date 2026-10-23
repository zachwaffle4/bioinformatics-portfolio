# Module 2: Explore (Assignment 2)

Basic tools for managing and analyzing genomic sequences on Northeastern's Explorer cluster. Each tutorial has its own folder with a README, the saved session, and the small files from that part.
Large data is on Explorer under `/courses/BIOL2406.202710/students/harel.z/inclass/` and is mapped in each README.

| Part | Folder | What it covers | Status |
|---|---|---|---|
| 1 | [`1_genomes/`](1_genomes/) | Downloading reference genomes, documenting them, `infoseq` | Done |
| 2 | [`2_bowtie2/`](2_bowtie2/) | Indexing and aligning lambda phage reads, samtools, bcftools | Done |
| 3 | [`3_variants/`](3_variants/) | fastqc, cutadapt, bowtie2, samtools, ANGSD on sea cucumber, plus in-class exercises | Done |
| 4 | [`4_mapping/`](4_mapping/) | Human RNA-seq reads, quality check, STAR index and alignment | Done (data and BAMs on Explorer) |

Tools used: fastqc, cutadapt, bowtie2, samtools, bcftools, angsd, emboss (`infoseq`), sratoolkit, and STAR (part 4).

Large text files are gzipped (`gunzip -k <file>.gz`).
