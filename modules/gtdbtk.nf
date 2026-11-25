process GTDB_CLASSIFY {
    // classify assembled genomes

    publishDir "${params.outdir}_${params.run_date}/classification", mode: 'link'

    input:
    path bins // MAG bins from vamb

    output:
    path "gtdb"

    script:
    """
  		gtdbtk classify_wf --genome_dir ${bins} --out_dir gtdb --cpus ${task.cpus}
  		"""
}
