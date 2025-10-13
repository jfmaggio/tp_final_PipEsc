process METAPHLAN3 {
    tag "$sample"
    publishDir "${params.outdir}/metaphlan", mode: 'copy'
    
    input:
    tuple val(sample), path(r1), path(r2)
    
    output:
    path "${sample}_profile.txt"
    path "${sample}_bowtie2.bz2"
    script:
    """
    metaphlan ${r1},${r2} --input_type fastq \\
        --bowtie2db "${params.metaphlan_db_path}" \\
        --index mpa_v30_CHOCOPhlAn_201901 \\
        --bowtie2out ${sample}_bowtie2.bz2 \\
        --nproc 4 -o ${sample}_profile.txt
    """
}