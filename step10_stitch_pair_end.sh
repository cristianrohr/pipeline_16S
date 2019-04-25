#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

OUTPUT_DIR=10_stitch_pair_end_reads
OUTPUT_LOG=${OUTPUT_DIR}/results.txt

mkdir ${OUTPUT_DIR}
touch ${OUTPUT_LOG}

run_pear.pl -p ${THREADS} -full_log ${OUTPUT_DIR}/pear_full_log.txt -summary_log ${OUTPUT_DIR}/pear_summary_log.txt -o ${OUTPUT_DIR} 00_raw_data/*

echo "Assembled: "$((`cat ${OUTPUT_DIR}/*.assembled.fastq | wc -l` / 4 | bc)) >> ${OUTPUT_LOG}
echo "Discarded: "$((`cat ${OUTPUT_DIR}/*.discarded.fastq | wc -l` / 4 | bc)) >> ${OUTPUT_LOG}
echo "Unassembled: "$((`cat ${OUTPUT_DIR}/*.unassembled.forward.fastq | wc -l` / 4 | bc)) >> ${OUTPUT_LOG}

# Stitching paired-end reads

# To start processing the data, we first need to stitch the paired-end reads together using PEAR (~1 min on 1 CPU):

# run_pear.pl -p 1 -o stitched_reads fastq/*fastq
# ("-p 1" indicates this job should be run on 1 CPU and "-o stitched_reads" indicates that the output folder).

# Four FASTQ files will be generated for each set of paired-end reads:
# (1) assembled reads (used for downstream analyses)
# (2) discarded reads (often abnormal reads, e.g. large run of Ns).
# (3) unassembled forward reads
# (4) unassembled reverse reads

# The default log file "pear_summary_log.txt" contains the percent of reads either assembled, discarded or unassembled.
