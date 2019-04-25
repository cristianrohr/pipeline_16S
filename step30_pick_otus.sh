#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=29_combine_fasta_files
OUTPUT_DIR=30_pick_otus
mkdir $OUTPUT_DIR

PO_OTU_PICKING_METHOD="sortmerna_sumaclust"
PO_PERCENT_SUBSAMPLE=0.1
PO_MIN_OTU_SIZE=1
PO_SORTMERNA_COVERAGE=0.8
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

	pick_open_reference_otus.py -f -v -i ${INPUT_DIR}/seqs.fna -o ${OUTPUT_DIR}/${SIM} -p ${OUTPUT_DIR}/${SIM}/clustering_params.txt -m ${PO_OTU_PICKING_METHOD} -s ${PO_PERCENT_SUBSAMPLE} --min_otu_size ${PO_MIN_OTU_SIZE}
done

# We will be using the sortmerna_sumaclust method of open-reference OTU picking. In open-reference OTU picking, reads are first clustered against a reference database; then, a certain percent (10% in the below command) of those reads that failed to be classified are sub-sampled to create a new reference database and the remaining unclassified reads are clustered against this new database. This de novo clustering step is repeated again by default using the below command (can be turned off to save time with the "–suppress_step4" option).

# Also, we are actually retaining singletons (i.e. OTUs identified by 1 read), which we will then remove in the next step. Note that "$PWD" is just a variable that contains your current directory. This command takes ~7 min with 1 CPU (note you may run into problems if the virtual box isn't using at least 2GB of RAM). Lowering the "-s" parameter's value will greatly affect running speed.

# Run the entire qiime open reference picking pipeline with the new sortmerna (for reference picking) and sumaclust (for de novo OTU picking). This does reference picking first, then subsamples failure sequences, de-novo OTU picks failures, ref picks against de novo OTUs, and de-novo picks again any left over failures. Note: You may want to change the subsampling percentage to a higher amount from the default -s 0.001 to -s 0.01 (e.g 1% of the failures) or -s 0.1 (e.g. 10% of the failures) (~24 hours).
