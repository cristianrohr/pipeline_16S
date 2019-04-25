#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=10_stitch_pair_end_reads
OUTPUT_DIR=13_stitch_pair_end_combined_qc
mkdir ${OUTPUT_DIR}

cd $OUTPUT_DIR
for TYPE in {assembled,discarded,unassembled.forward,unassembled.reverse}
do
	cat ../${INPUT_DIR}/*.${TYPE}.fastq | fastqc -t ${THREADS} -o . stdin
	mv stdin_fastqc.html ${TYPE}.combined_fastqc.html
	mv stdin_fastqc.zip ${TYPE}.combined_fastqc.zip
done
multiqc
rm -f *.zip
cd ..
