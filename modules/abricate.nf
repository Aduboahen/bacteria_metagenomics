process ABRICATE_CONTIGS {
    // run abricate on raw assembled contigs to 
    // determine resistance genes present in metagenome
    label "abricate contigd"
    publishDir "${params.outdir}/resistance", mode: 'copy',  pattern: '*.csv'

    input:
        path mag_files
    output:
        path "raw_assembly_resistance_genes.csv"
    script:
        """
        abricate --threads ${params.threads} --csv --quiet ${mag_files} > raw_assembly_resistance_genes.csv
        """
}

process ABRICATE_BINS {
    // run abricate on binned assemblies to 
    // determine resistance genes present in metagenome
    label "abricate bins"
    publishDir "${params.outdir}/resistance", mode: 'copy', pattern: '*.csv'

    input:
        path mag_bins
    output:
        path "bins_resistance_genes.csv"
    script:
        """
        abricate --threads ${params.threads} --csv --quiet  ${mag_bins} > bins_resistance_genes.csv
        """
}