#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=29_combine_fasta_files
OUTPUT_DIR=30_pick_otus_closed_reference
mkdir $OUTPUT_DIR

#PO_OTU_PICKING_METHOD="sortmerna_sumaclust"
#PO_PERCENT_SUBSAMPLE=0.1
#PO_MIN_OTU_SIZE=1
#PO_SORTMERNA_COVERAGE=0.8
#PO_SIMILARITY=0.90

LEVELS=$(echo ${SIMILARITYS} | tr "," "\n")

for i in ${LEVELS}
do
	echo -e "\tSIMILARITY: ${i}"
	SIM=${i}_percent_similarity
	mkdir -p ${OUTPUT_DIR}/${SIM}
	PO_SIMILARITY=0.${i}
	echo "pick_otus:threads ${THREADS}" > ${OUTPUT_DIR}/${SIM}/clustering_params.txt
	#echo "pick_otus:sortmerna_coverage ${PO_SORTMERNA_COVERAGE}" >> $OUTPUT_DIR/clustering_params.txt
	echo "pick_otus:similarity ${PO_SIMILARITY}" >> ${OUTPUT_DIR}/${SIM}/clustering_params.txt

	pick_closed_reference_otus.py -f -i ${INPUT_DIR}/seqs.fna -o ${OUTPUT_DIR}/${SIM} -p ${OUTPUT_DIR}/${SIM}/clustering_params.txt 
done
