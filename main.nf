#!/usr/bin/env nextflow

nextflow.enable.dsl=2


params.outdir   = 'results'
params.sampleid = 'ERR5000343_sub12'
params.threads  =  4
params.quality = 8
params.length = 1000
params.read = "$projectDir/sub12/ERR5000343_sub12.fastq.gz"

// module
include {clean_reads; clean_reads as clean_reads2} from './modules/qc'
include {assign_taxonomic; extract_human_reads} from './modules/assign_taxa'
include {assemble_mags} from './modules/assemble_mags'
include {abundance_estimation} from './modules/count_matrix'
include {concatenate_mags} from './modules/concatenate_mags'


workflow {
	fastq = Channel.fromPath(params.read).ifEmpty{"no such file"}
	clean_reads(fastq)
	clean_reads2(fastq)
	assign_taxonomic(clean_reads.out.read)
	abundance_estimation(clean_reads.out.read, assign_taxonomic.out.taxa_file)
	extract_human_reads(clean_reads2.out.read, assign_taxonomic.out.taxa_file)
	assemble_mags(extract_human_reads.out)
	// concatenate_mags(assemble_mags.out)

}