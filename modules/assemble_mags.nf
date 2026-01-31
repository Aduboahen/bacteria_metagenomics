process	assemble_mags {
	tag 'assemble_mags'
	publishDir "${params.outdir}/mags", mode: 'copy', pattern: "*"

	input:
		path read // 'Input read file (fastq)'

	output:
		path "${params.sampleid}", emit: mags_file // 'Assembled MAGs in FASTA format'

	script:
		"""
		flye --nano-hq ${read} -o ${params.sampleid} --meta --threads ${params.threads}

		awk -v s="${params.sampleid}_" '/^>/ {\$0=">" s substr(\$0,2)} 1 ' ${params.sampleid}/assembly.fasta > ${params.sampleid}/assembly_renamed.fasta

		mv "${params.sampleid}/assembly_renamed.fasta" "${params.sampleid}/${params.sampleid}.assembly.fasta"
		"""
}