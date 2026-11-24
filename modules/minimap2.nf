process MINIMAP2_REMOVE_HOST_READS {
    // remove host reads
    tag "${sample_id}"
    label "mapping"
    publishDir "${params.outdir}/fastq/host_depleted", mode: 'link', pattern: "*.fastq.gz"

    input:
    tuple val(sample_id), path(read)
    // 'Input read file (fastq)'
    path hosts

    output:
    tuple val(sample_id), path("${sample_id}_cleaned.fastq.gz")

    script:
    """
   			minimap2 -ax map-ont -t ${params.threads} ${hosts} ${read} | \
   			samtools sort | \
   			samtools view -f 4 | \
   			samtools fastq - > ${sample_id}_cleaned.fastq

   			gzip ${sample_id}_cleaned.fastq
   		"""
}


process MINIMAP2_MAP_CATALOGUE {
    // map host depleted reads to mag catalogue
    tag "${sample_id}"
    label "mapping"
    publishDir "${params.outdir}/bams", mode: 'link', pattern: "*.bam"
    publishDir "${params.outdir}/bams", mode: 'link', pattern: "*.stats"
    publishDir "${params.outdir}/bams", mode: 'link', pattern: "*.idxstats"
    publishDir "${params.outdir}/bams", mode: 'link', pattern: "*.bai"

    input:
    path mags_catalogue
    // 'Input MAGs file (fna)'
    tuple val(sample_id), path(read)

    output:
    path ("${sample_id}.bam"), emit: bam
    path "${sample_id}.bam.stats"
    path "${sample_id}.bam.idxstats"
    path ("${sample_id}.bam.bai"), emit: bai

    script:
    """
   		minimap2 -ax map-ont -t ${params.threads} ${mags_catalogue} ${read} | samtools sort - | samtools view -F 3844 -b -o ${sample_id}.bam -@ ${params.threads}

   		samtools index ${sample_id}.bam > ${sample_id}.bam.bai

   		samtools idxstats ${sample_id}.bam > ${sample_id}.bam.idxstats

   		samtools stats ${sample_id}.bam > ${sample_id}.bam.stats
   		"""
}
