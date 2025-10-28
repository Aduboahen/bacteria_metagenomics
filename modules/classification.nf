process classify {

	tag 'classify_reads'
	conda '/home/james/miniconda3/envs/bacteria_meta'
	publishDir "${params.outdir}/classification", mode: 'copy', pattern: "*.kraken"

	input:
		path mag_files // 'Input reads file (fastq)'

	script:
		"""
		gtdbtk classify_wf --genome_dir ${mag_files} --out_dir ${params.outdir}/classification --cpus ${params.threads}
		"""
}