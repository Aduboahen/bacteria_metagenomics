process GTDB_CLASSIFY {
	label "gtdb classification"
	publishDir "${params.outdir}/classification", mode: 'copy'

	input:
		path bins // MAG bins from vamb
	
	output:
		path "gtdb"

	script:
		"""
		gtdbtk classify_wf --genome_dir ${bins} --out_dir gtdb --cpus ${task.cpus}
		"""
}