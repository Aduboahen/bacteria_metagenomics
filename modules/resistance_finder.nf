process abricate_contigs {
    // run abricate on raw assembled contigs to 
    // determine resistance genes present in metagenome
    tag ${params.sampleid}
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

process abricate_bins {
    // run abricate on binned assemblies to 
    // determine resistance genes present in metagenome
    tag ${params.sampleid}
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