process ALPHA_DIVERSITY {
    // calculate alpha diversity from bracken files
    tag "${sample_id}"
    label "diversity"
    publishDir "${params.outdir}/${params.run_date}/diversity", mode: 'link'

    input:
    tuple val(sample_id), path(bracken_file)

    output:
    path "${sample_id}.alpha"

    script:
    """
   		alpha_diversity.py -f ${bracken_file} -a BP > ${sample_id}.alpha
   		"""
}


process BETA_DIVERSITY {
    // calculate beta diversity from bracken files
    label "diversity"
    publishDir "${params.outdir}/${params.run_date}/diversity", mode: 'link'

    input:
    path bracken_files

    output:
    path "beta_diversity"

    script:
    """
   			beta_diversity.py --input ${bracken_files} --type bracken > beta_diversity
   		"""
}
