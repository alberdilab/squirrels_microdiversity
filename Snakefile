from snakemake.io import glob_wildcards

GENOMES = glob_wildcards("genomes/{genome}.fa").genome
SAMPLES = glob_wildcards("mapping/{sample}.bam").sample

rule all:
    input:
        expand("lorikeet/{genome}/{genome}.vcf", genome=GENOMES)

rule subset_bam:
    input:
        genome=f"genomes/{{genome}}.fa",
        bam=f"mapping/{{sample}}.bam"
    output:
        txt=f"filtered/{{genome}}/{{sample}}.txt",
        bam=f"filtered/{{genome}}/{{sample}}.bam",
        bai=f"filtered/{{genome}}/{{sample}}.bam.bai"
    threads: 1
    resources:
        mem_mb=lambda wildcards, input, attempt: max(8*1024, int(input.size_mb * 5) * 2 ** (attempt - 1)),
        runtime=lambda wildcards, input, attempt: max(10, int(input.size_mb / 1024 * 10) * 2 ** (attempt - 1))
    shell:
        """
        source activate lorikeet
        samtools index {input.bam}
        samtools idxstats {input.bam} | cut -f1 | grep -E "^{wildcards.genome}\\^" > {output.txt}
        samtools view -F4 -h {input.bam} $(cat {output.txt}) | samtools sort -o {output.bam}
        samtools index {output.bam}
        """

rule lorikeet_call:
    input:
        genome=f"genomes/{{genome}}.fa",
        bams=lambda wc: expand(
            "filtered/{genome}/{sample}.bam",
            genome=wc.genome,
            sample=SAMPLES
        )
    output:
        f"lorikeet/{{genome}}/{{genome}}.vcf"
    threads: 8
    resources:
        mem_mb=lambda wildcards, input, attempt: max(8*1024, int(input.size_mb * 100) * 2 ** (attempt - 1)),
        runtime=lambda wildcards, input, attempt: max(15, int(input.size_mb / 20) * 2 ** (attempt - 1))
    shell:
        """
        source activate lorikeet
		lorikeet call -t {threads} -r {input.genome} -b {input.bams} -o lorikeet/
        """
