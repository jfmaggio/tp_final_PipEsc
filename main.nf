// main.nf
nextflow.enable.dsl=2

include { FILTRADO_QC } from './modules/filtrado_qc.nf'
include { REMOCION_HOSPEDADOR } from './modules/remocion_hospedador.nf'
include { METAPHLAN3 } from './modules/MetaPhlAn3.nf'

   

workflow {
    // Canal de lecturas
    reads_ch = Channel.fromFilePairs(params.input)
                      .map { sample, files -> tuple(sample, files[0], files[1]) }
    
    // QC filtering
    trimmed_ch = FILTRADO_QC(reads_ch)
    
    // Preparar el índice del host (se colecta una sola vez)
    host_index_ch = Channel
        .fromPath("${params.host_index_dir}/GRCh38_noalt_as*", checkIfExists: true)
        .collect()
    
    // Remover host - el índice se pasa como path separado
    host_removed_ch = REMOCION_HOSPEDADOR(trimmed_ch, host_index_ch)
    
    // MetaPhlAn3
    METAPHLAN3(host_removed_ch)
}