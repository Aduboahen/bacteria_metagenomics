process classify {
	tag 'classify_reads'
	publishDir "${params.outdir}/classification", mode: 'copy'

	input:
		path bins // MAG bins from vamb

	script:
		"""
		gtdbtk classify_wf --genome_dir ${bins} --out_dir gtdb --cpus ${task.cpus}
		"""
}