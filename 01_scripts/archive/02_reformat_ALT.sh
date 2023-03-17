#!/bin/bash

# Merge SVs from both short and long reads with Jasmine
# Jasmine must be installed in current env or session

# valeria
# srun -c 10 -p ibis_small --mem=200G -J 01_merge_SRLR_symALT -o log/01_merge_SRLR_symALT_%j.log /bin/sh 01_scripts/01_merge_SRLR_symALT.sh &

# manitou
# srun -c 10 -p small --mem=200G -J 01_merge_SRLR_symALT -o log/01_merge_SRLR_symALT_%j.log /bin/sh 01_scripts/01_merge_SRLR_symALT.sh &
 
# VARIABLES
GENOME="03_genome/genome.fasta"
VCF_DIR="04_vcf"
MERGED_DIR="05_merged"
FILT_DIR="06_filtered"

SR_VCF="$VCF_DIR/SR/merged_delly_manta_smoove_SUPP2.symALT.vcf"
LR_VCF="$VCF_DIR/LR/merged_sniffles_svim_nanovar_SUPP2.symALT.vcf"

VCF_LIST="02_infos/VCFs_symALT.txt"
MERGED_VCF="$MERGED_DIR/merged_SUPP2_symALT.vcf"

REGIONS_EX="02_infos/excl_chrs.txt"

# 1. Reconvert symbolic alleles to explicit sequences stored in original VCF
Rscript 01_scripts/utils/reconvert_ALT.R $MERGED_VCF $LR_VCF $SR_VCF $MERGED_DIR/"$(basename -s $MERGED_VCF)"_ALT.vcf

# 2