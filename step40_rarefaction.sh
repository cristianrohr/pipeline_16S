#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=30_pick_otus
OUTPUT_DIR=40_rarefaction
mkdir $OUTPUT_DIR

LEVELS=$(echo $SIMILARITYS | tr "," "\n")

for i in $LEVELS
do
        echo -e "\tSIMILARITY: $i"
        SIM=${i}_percent_similarity

	mkdir -p ${OUTPUT_DIR}/${SIM}

	# Get the value of the less represented sample, this will be the rarefaction value
	SUBSET=`grep " Min: " ${INPUT_DIR}/${SIM}/otu_table_high_conf_summary.txt | cut -d ' ' -f 3 | cut -f 1 -d '.'`
	echo -e "Subset\t${SUBSET}"


	# Get the maximum value, this will the value for the multiple rarefactions, as Santiago does
#	MAX=`grep " Max: " ${INPUT_DIR}/${SIM}/otu_table_high_conf_summary.txt | cut -d ' ' -f 3 | cut -f 1 -d '.'`
#	echo -e "Max\t${MAX}"

	# Run rarefaction
	single_rarefaction.py -i ${INPUT_DIR}/${SIM}/otu_table_high_conf.biom -o ${OUTPUT_DIR}/${SIM}/otu_table.biom -d ${SUBSET}

	# Minimun value for the rarefactions, and step i want 10 steps
#	MIN=$(echo 0.1*$MAX | bc)
#	int=${MIN%.*}
#	MIN=${int}
#	echo -e "MIN\t${MIN}"
	
#	STEP=$(($MAX/10))
#	echo -e "STEP\t${STEP}"

	# Run multiple rarefactions
#	multiple_rarefactions.py -m ${MIN} -x ${MAX} -s ${STEP} -n 2 -i ${INPUT_DIR}/${SIM}/otu_table_high_conf.biom -o ${OUTPUT_DIR}/${SIM}/rarefied/

done

# Rarify reads

# We now need to subsample the number of reads for each sample to the same depth, which is necessary for several downstream analyses. This is called rarefaction, a technique that provides an indication of species richness for a given number of samples. There is actually quite a lot of debate about whether rarefaction is necessary (since it throws out data!), but it is still the standard method used in microbiome studies. We want to rarify the read depth to the sample with the lowest "reasonable" number of reads. Of course, a "reasonable" read depth is quite subjective and depends on how much variation there is between samples.

# You can look at the read depth per sample in clustering/otu_table_high_conf_summary.txt, here are the first five samples (they are sorted from smallest to largest):

# This QIIME command produced another BIOM table with each sample rarified to 12,452 reads. In this case no OTUs were lost due to this sub-sampling 

# (which you can confirm by producing a summary table), but this step often will result in low-frequency OTUs being lost from the analysis.

