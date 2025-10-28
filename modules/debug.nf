process bin_qc_debug {
    tag 'mag_bin_qc_debug'
    conda '/home/james/miniconda3/envs/checkm2'
    publishDir "${params.outdir}/checkm_debug", mode: 'copy'

    input:
        path bin_dir        // accept whatever the upstream channel gives

    output:
        path "checkm_debug_out", emit: qc

    script:
    """
    set -x
    mkdir -p checkm_debug_out
    echo "=== DEBUG: environment ===" > checkm_debug_out/debug.log
    echo "USER: $(id -un)" >> checkm_debug_out/debug.log
    echo "UID: $(id -u)  GID: $(id -g)" >> checkm_debug_out/debug.log
    echo "PWD: \$PWD" >> checkm_debug_out/debug.log
    echo "BIN_DIR_RAW (as received): ${bin_dir}" >> checkm_debug_out/debug.log
    echo "ls -ld (staged):" >> checkm_debug_out/debug.log
    ls -ld "${bin_dir}" >> checkm_debug_out/debug.log 2>&1 || true
    echo "ls -l of contents:" >> checkm_debug_out/debug.log
    ls -l "${bin_dir}" >> checkm_debug_out/debug.log 2>&1 || true

    echo "readlink -f on received path:" >> checkm_debug_out/debug.log
    readlink -f "${bin_dir}" >> checkm_debug_out/debug.log 2>&1 || true

    # test opening one file (first fasta) if exists
    FIRSTF=$(ls "${bin_dir}"/*.fna "${bin_dir}"/*.fa "${bin_dir}"/*.fasta 2>/dev/null | head -n1 || true)
    echo "FIRSTF: \$FIRSTF" >> checkm_debug_out/debug.log
    if [ -n "\$FIRSTF" ]; then
        echo "head -n1 of FIRSTF:" >> checkm_debug_out/debug.log
        head -n2 "\$FIRSTF" >> checkm_debug_out/debug.log 2>&1 || true
    else
        echo "No fasta files found in the directory." >> checkm_debug_out/debug.log
    fi

    echo "which checkm2" >> checkm_debug_out/debug.log
    which checkm2 >> checkm_debug_out/debug.log 2>&1 || true
    echo "checkm2 --version" >> checkm_debug_out/debug.log
    checkm2 --version >> checkm_debug_out/debug.log 2>&1 || true

    echo "TRY 1: run checkm2 with the received (staged) path" >> checkm_debug_out/debug.log
    checkm2 predict --input "${bin_dir}" --output-directory "checkm_try1" --threads ${params.threads} --allmodels --database_path ${params.CHECKMDB} --resume >> checkm_debug_out/checkm_try1.log 2>&1 || echo "EXIT:$?" >> checkm_debug_out/checkm_try1.log || true
    echo "TRY 1 RC: \$? " >> checkm_debug_out/debug.log

    echo "TRY 2: run checkm2 with absolute path readlink -f" >> checkm_debug_out/debug.log
    ABS=\$(readlink -f "${bin_dir}" 2>/dev/null || realpath "${bin_dir}" 2>/dev/null || echo "")
    echo "ABS: \$ABS" >> checkm_debug_out/debug.log
    if [ -n "\$ABS" ]; then
        checkm2 predict --input "\$ABS" --output-directory "checkm_try2" --threads ${params.threads} --allmodels --database_path ${params.CHECKMDB} --resume >> checkm_debug_out/checkm_try2.log 2>&1 || echo "EXIT:$?" >> checkm_debug_out/checkm_try2.log || true
        echo "TRY 2 RC: \$? " >> checkm_debug_out/debug.log
    else
        echo "Could not compute ABS path" >> checkm_debug_out/debug.log
    fi

    echo "TRY 3: create a symlink to absolute path and run checkm2 on it" >> checkm_debug_out/debug.log
    mkdir -p link_test
    ln -s "\${PWD}/${bin_dir}" link_test/bins_link || true
    ls -l link_test >> checkm_debug_out/debug.log 2>&1 || true
    checkm2 predict --input "link_test/bins_link" --output-directory "checkm_try3" --threads ${params.threads} --allmodels --database_path ${params.CHECKMDB} --resume >> checkm_debug_out/checkm_try3.log 2>&1 || echo "EXIT:$?" >> checkm_debug_out/checkm_try3.log || true
    echo "TRY 3 RC: \$? " >> checkm_debug_out/debug.log

    echo "DONE" >> checkm_debug_out/debug.log

    # Collect logs to output dir
    mv checkm_try1* checkm_try2* checkm_try3* checkm_debug_out || true
    """
}
