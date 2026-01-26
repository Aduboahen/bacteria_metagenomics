process classify {

	tag 'classify_reads'
	publishDir "${params.outdir}/classification", mode: 'copy', pattern: "*.kraken"

	input:
		path mag_files // MAG bins from vamb

	script:
		"""
		gtdbtk classify_wf --genome_dir ${mag_files} --out_dir ${params.outdir}/classification --cpus ${params.threads}
		"""
}