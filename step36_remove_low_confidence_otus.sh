#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

INPUT_DIR=30_pick_otus

LEVELS=$(echo $SIMILARITYS | tr "," "\n")

for i in $LEVELS
do
	echo -e "\tSIMILARITY: $i"
        SIM=${i}_percent_similarity
	remove_low_confidence_otus.py -i ${INPUT_DIR}/${SIM}/otu_table_mc1_w_tax_no_pynast_failures.biom -o ${INPUT_DIR}/${SIM}/otu_table_high_conf.biom
done

# Filter OTU table to remove singletons as well as low-confidence OTUs that are likely due to MiSeq bleed-through between runs (reported by Illumina to be 0.1% of reads).

# We will now remove low confidence OTUs, i.e. those that are called by a low number of reads. It's difficult to choose a hard cut-off for how many reads are needed for an OTU to be confidently called, since of course OTUs are often at low frequency within a community. A reasonable approach is to remove any OTU identified by fewer than 0.1% of the reads, given that 0.1% is the estimated amount of sample bleed-through between runs on the Illumina Miseq:
