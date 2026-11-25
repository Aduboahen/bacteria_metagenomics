process VAMB_BINNING {
    label "vamb"
    publishDir "${params.outdir}/${params.run_date}", mode: 'link'

    input:
    path contigs_catalogue
    // 'Input contigs catalogue (fasta)'
    path "bams/*"
    // sorted bam file mapped to contigs catalogue
    val bin_size

    output:
    path "vamb/bins", emit: 'bins' // directory containing vamb bins
    path "vamb/bins/*.fna", emit: 'fasta' // vamb generated fasta files for each bin
    path "vamb"

    script:
    """
   			vamb bin default --fasta ${contigs_catalogue} --outdir "vamb" --bamdir bams --minfasta ${bin_size} -p ${task.cpus} --seed 373
   		"""
}

process VAMB_CONCAT {
    label "vamb"
    publishDir "${params.outdir}/${params.run_date}/contigs", mode: 'link', pattern: "*"

    input:
    path contigs_files // 'Path to saamebled contigs files for all samples'

    output:
    path "contigs_catalogue.fna", emit: contigs_catalogue // 'Concatenated contigs in FASTA format'
    path "contigs_catalogue.mmi" // contigs catalogue index file

    script:
    """
 			python ${params.vamb_concat} contigs_catalogue.fna ${contigs_files}

  			minimap2 -d contigs_catalogue.mmi contigs_catalogue.fna
  		"""
}
