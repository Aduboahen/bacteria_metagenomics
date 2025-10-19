#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.outdir   = "$projectDir/results"
params.sampleid = "ERR5000343_sub12"
params.threads  =  10
params.quality = 8
params.length = 1000
params.read = "$projectDir/sub12/ERR5000343_sub12.fastq.gz"
params.KRAKEN2_DB = "$projectDir/k2_standard_16_GB_20250714" // path to kraken2 database

process concat_mags {
	tag 'concatenate mags'
	publishDir "${params.outdir}/mags", mode: 'copy', pattern: "*"
	conda '/home/james/miniconda3/envs/bacteria_meta'

	input:
		path mags_files // 'Path to saamebled MAGs files for all samples'

	output:
		path "mags_catalogue.fna",  emit: mags_catalogue // 'Concatenated MAGs in FASTA format'
		path "mags_catalogue.mmi" // MAG catalogue index file

	script:
		"""
			source /home/james/.virtualenvs/vamb/bin/activate
			
			python /home/james/repos/github/vamb/src/concatenate.py mags_catalogue.fna $mags_files --nozip

			minimap2 -d mags_catalogue.mmi mags_catalogue.fna
		"""
}