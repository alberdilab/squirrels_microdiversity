# squirrels_microdiversity
Squirrels microdiversity analysis using Lorikeet

sh```
genome=EHA02405_bin.30
fasta=https://sid.erda.dk/share_redirect/BaMZodj9sA/MAG/ABB0278/EHA02405_bin.30.fa.gz
cd genomes
wget $fasta


module load {params.samtools_module}
mkdir filtered
mkdir filtered/EHA02405_bin.30
samtools index mapping/PRB0009_EHI00142_DMB0046.bam

samtools view -F4 -h mapping/PRB0009_EHI00142_DMB0046.bam | grep 'EHA02405_bin.30' | samtools sort -o filtered/EHA02405_bin.30/PRB0009_EHI00142_DMB0046.bam
samtools index filtered/EHA02405_bin.30/PRB0009_EHI00142_DMB0046.bam

mkdir lorikeet
mkdir lorikeet/EHA02405_bin.30
lorikeet call -r genomes/EHA02405_bin.30.fna -b filtered/EHA02405_bin.30 -o lorikeet/EHA02405_bin.30

```
