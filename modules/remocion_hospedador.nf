process REMOCION_HOSPEDADOR {
    tag "$sample"
    publishDir "${params.outdir}/host_removed", mode: 'copy'
    
    input:
    tuple val(sample), path(r1), path(r2)
    path host_index_files
    
    output:
    tuple val(sample), path("${sample}_R1.clean.fq.gz"), path("${sample}_R2.clean.fq.gz")
    
    script:
    def index_name = host_index_files[0].simpleName.replaceAll(/\.[0-9]+$/, '')
    """
    bowtie2 -x ${index_name} -1 ${r1} -2 ${r2} --very-sensitive -S ${sample}.sam
    samtools view -b -f 4 -F 256 ${sample}.sam > ${sample}.host_removed.bam
    samtools fastq -1 ${sample}_R1.clean.fq.gz -2 ${sample}_R2.clean.fq.gz ${sample}.host_removed.bam
    """
}