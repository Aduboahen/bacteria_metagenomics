process	assemble_mags {
	tag 'assemble_mags'
	conda '/home/james/miniconda3/envs/meta_assembler'
	publishDir "${params.outdir}/mags", mode: 'copy', pattern: "*"

	input:
		path read // 'Input read file (fastq)'

	output:
		path "${params.sampleid}", emit: mags_file // 'Assembled MAGs in FASTA format'

	script:
		"""
		flye --nano-hq ${read} -o ${params.sampleid} --threads ${params.threads}

		mv "${params.sampleid}/assembly.fasta" "${params.sampleid}/${params.sampleid}.assembly.fasta"
		"""
}