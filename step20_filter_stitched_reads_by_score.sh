#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=10_stitch_pair_end_reads
OUTPUT_DIR=20_filter_stitched_reads_score

# RF_QC quality score cut-off of over XX
# RF_QC_OVER over XX% of bases
# RF_MIN_LENGTH minimun length of XX

read_filter.pl -q ${RF_QC} -p ${RF_QC_OVER} -l ${RF_MIN_LENGTH} -f ${FORWARD} -r ${REVERSE} --thread ${THREADS} ${INPUT_DIR}/*.assembled.* -o ${OUTPUT_DIR} -log ${OUTPUT_DIR}/read_filter_log.txt

# Filtering reads by quality and length

# Based on the FastQC report above, a quality score cut-off of 30 over 90% of bases 
#and a maximum length of 400 bp are reasonable filtering criteria (~2 min on 1 CPU):

# read_filter.pl -q 30 -p 90 -l 400 -thread 1 stitched_reads/*.assembled*fastq
# By default this script will output filtered FASTQs in a folder called "filtered_reads"
# and the percent of reads thrown out after each filtering step is recorded in "read_filter_log.txt".

# If you look in this logfile you will note that ~40% of reads were filtered out for each sample.
# You can also see the counts and percent of reads dropped at each step.
