process ABRICATE_CONTIGS {
    // run abricate on raw assembled contigs to
    // determine resistance genes present in metagenome

    label 'abricate'
    publishDir "${params.outdir}/${params.run_date}/resistance", mode: 'copy', pattern: '*.csv'

    input:
    path contigs_files

    output:
    path "raw_assembly_resistance_genes.csv"

    script:
    """
        abricate --threads ${task.cpus} --csv --quiet ${contigs_files} > raw_assembly_resistance_genes.csv
        ${params.format_abricate} --abricate raw_assembly_resistance_genes.csv
        """
}

process ABRICATE_MAGS {
    // run abricate on binned assemblies to
    // determine resistance genes present in metagenome
    label 'abricate'
    publishDir "${params.outdir}/${params.run_date}/resistance", mode: 'copy', pattern: '*.csv'

    input:
    path mag_bins

    output:
    path "mags_resistance_genes.csv"

    script:
    """
        abricate --threads ${task.cpus} --csv --quiet  ${mag_bins} > mags_resistance_genes.csv
        ${params.format_abricate} --abricate mags_resistance_genes.csv
        """
}
