cd /courses/BIOL2406.202710/students/harel.z/bioinformatics-portfolio/module-1-unix/data
ls -l
grep -c "ACGT" *.fasta
grep -c "AC.GT" *.fasta
grep -c "AC*GT" *.fasta
grep -n "ATCG.*TAG$" chr1.fasta | head
grep -n "ATCG.*TAG$" intron_IME_data.fasta | head
tr 'A-Z' 'a-z' < chr1.fasta > smallcase_chr1.fasta
head -n 3 smallcase_chr1.fasta
ls
mv smallcase_chr1.fasta "$(echo smallcase_chr1.fasta | sed 's/smallcase/lowercase/')"
ls
tail -n 500 At_genes.gff > At_genes_last500.gff
wc -l At_genes_last500.gff
head -n 3 At_genes_last500.gff
cut -f 5,7 At_genes.gff | head
tr '\n' '@' < intron_IME_data.fasta | sed 's/>/#>/g' | tr '#' '\n' | grep "i1_.*5UTR" | sort -nk 3 -t "_" | head -n 5 | tr '@' '\n'
