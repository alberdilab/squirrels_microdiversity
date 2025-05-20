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

samtools index mapping/PRB0141_EHI01511_DMB0046.bam
samtools idxstats mapping/PRB0141_EHI01511_DMB0046.bam | cut -f1 | grep '^EHA02405_bin\.30\^' > mapping/PRB0141_EHI01511_DMB0046.txt
samtools view -F4 -h mapping/PRB0141_EHI01511_DMB0046.bam $(cat mapping/PRB0141_EHI01511_DMB0046.txt) | samtools sort -o filtered/EHA02405_bin.30/PRB0141_EHI01511_DMB0046.bam
samtools index filtered/EHA02405_bin.30/PRB0141_EHI01511_DMB0046.bam

mkdir lorikeet
mkdir lorikeet/EHA02405_bin.30
conda activate lorikeet
lorikeet call -r genomes/EHA02405_bin.30.fa -b filtered/EHA02405_bin.30/*bam -o lorikeet/EHA02405_bin.30

```
