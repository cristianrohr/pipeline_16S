#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
source $DIR/xx_scripts/vars.sh

OTU_DIR=30_pick_otus
INPUT_DIR=40_rarefaction
OUTPUT_DIR=70_beta_diversity
mkdir ${OUTPUT_DIR}

LEVELS=$(echo ${SIMILARITYS} | tr "," "\n")

for i in ${LEVELS}
do
        echo -e "\tSIMILARITY: ${i}"
        SIM=${i}_percent_similarity

        mkdir -p ${OUTPUT_DIR}/${SIM}

	echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > ${OUTPUT_DIR}/${SIM}/beta_parameters.txt

	beta_diversity_through_plots.py -p ${OUTPUT_DIR}/${SIM}/beta_parameters.txt -m ${MAPPING_FILE} -t ${OTU_DIR}/${SIM}/rep_set.tre -i ${INPUT_DIR}/${SIM}/otu_table.biom -o ${OUTPUT_DIR}/${SIM}/bdiv_out

done

for i in ${LEVELS}
do
	echo -e "\tSIMILARITY: ${i}"
        SIM=${i}_percent_similarity
	for j in {bray_curtis_pc,unweighted_unifrac_pc,weighted_unifrac_pc}
	do
		make_2d_plots.py -i ${OUTPUT_DIR}/${SIM}/bdiv_out/${j}.txt -m ${MAPPING_FILE}  -o ${OUTPUT_DIR}/${SIM}/bdiv_out/2d_plots
	done
done

# Diversity analyses

## Diversity in microbial samples can be expressed in a number of ways. Most commonly people refer to "alpha" (the diversity within a group) and "beta" (the diversity between groups) diversity. There are many different ways to compute both of these diversities.

# UniFrac beta diversity analysis

## UniFrac is a particular beta-diversity measure that analyzes dissimilarity between samples, sites, or communities. We will now create UniFrac beta diversity (both weighted and unweighted) principal coordinates analysis (PCoA) plots. PCoA plots are related to principal components analysis (PCA) plots, but are based on any dissimilarity matrix rather than just a covariance/correlation matrix (< 1 min on 1 CPU):

## This QIIME script takes as input the final OTU table, as well as file which contains the phylogenetic relatedness between all clustered OTUs. One HTML file will be generated for the weighted and unweighted beta diversity distances:

## plots/bdiv_otu/weighted_unifrac_emperor_pcoa_plot/index.html
## plots/bdiv_otu/unweighted_unifrac_emperor_pcoa_plot/index.html
## Open the weighted HTML file in your browser and take a look, you should see this PCoA:
