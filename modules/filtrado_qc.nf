process FILTRADO_QC {
    tag "$sample"
    publishDir "${params.outdir}/qc", mode: 'copy'
    
    input:
    tuple val(sample), path(r1), path(r2)
    
    output:
    tuple val(sample), path("${sample}_R1.trimmed.fq.gz"), path("${sample}_R2.trimmed.fq.gz")
    
    script:
    """
    R1_BASE=\$(basename ${r1} .fastq.gz)
    R2_BASE=\$(basename ${r2} .fastq.gz)
    trim_galore --paired --quality 20 --length 75 --max_n 2 --trim-n \\
        --output_dir . ${r1} ${r2}
    mv \${R1_BASE}_val_1.fq.gz ${sample}_R1.trimmed.fq.gz
    mv \${R2_BASE}_val_2.fq.gz ${sample}_R2.trimmed.fq.gz
    """
}