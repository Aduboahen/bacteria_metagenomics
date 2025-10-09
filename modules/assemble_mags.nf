process	assemble_mags {
	tag 'assemble_mags'
	publishDir "${params.outdir}/mags", mode: 'copy', pattern: "*.fna.gz"

	input:
		path read // 'Input read file (fastq)'

	output:
		path "${params.sampleid}_assembled_mags.fna.gz", emit: mags_file // 'Assembled MAGs in FASTA format'

	script:
		"""
		metaspades.py --nanopore ${read} -o ${params.sampleid}_assembled_mags \
		--threads ${params.threads} --only-assembler
		
		gzip ${params.sampleid}_assembled_mags/contigs.fasta -c > ${params.sampleid}_assembled_mags.fna.gz
		"""
}