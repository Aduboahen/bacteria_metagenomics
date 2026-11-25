process FLYE_ASSEMBLE {
    // asseble genomes with flye
    tag "${sample_id}"
    publishDir "${params.outdir}_${params.run_date}/assembly", mode: 'link', pattern: "*"

    input:
    tuple val(sample_id), path(read)

    output:
    path ("${sample_id}/${sample_id}.assembly.fasta"), emit: contigs_file
    path "${sample_id}/"

    script:
    """
   		flye --nano-hq ${read} -o ${sample_id} --meta --threads ${task.cpus}

   		awk -v s="${sample_id}_" '/^>/ {\$0=">" s substr(\$0,2)} 1 ' ${sample_id}/assembly.fasta > ${sample_id}/assembly_renamed.fasta

   		mv "${sample_id}/assembly_renamed.fasta" "${sample_id}/${sample_id}.assembly.fasta"

   		rm "${sample_id}/assembly.fasta"
   		"""
}
