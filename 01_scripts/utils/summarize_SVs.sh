#!/bin/bash

# Explore merged SVs

# valeria
# srun -c 1 -p ibis_small --time=1-00:00:00 --mem=50G -J summarize_SVs -o log/summarize_SVs_%j.log /bin/sh 01_scripts/utils/summarize_SVs.sh &

# manitou
# srun -c 1 -p small --time=1-00:00:00 --mem=50G -J summarize_SVs -o log/summarize_SVs_%j.log /bin/sh 01_scripts/utils/summarize_SVs.sh &
 
# VARIABLES
GENOME="03_genome/genome.fasta"
VCF_DIR="04_vcf"
MERGED_DIR="05_merged"
FILT_DIR="06_filtered"

SR_VCF="$VCF_DIR/SR/merged_delly_manta_smoove_SUPP2.vcf"
LR_VCF="$VCF_DIR/LR/merged_sniffles_svim_nanovar_SUPP2.vcf"

VCF_LIST="02_infos/VCFs.txt"
MERGED_VCF="$MERGED_DIR/merged_SUPP2.vcf"

REGIONS_EX="02_infos/excl_chrs.txt"

# LOAD REQUIRED MODULES
module load bcftools/1.13


# 1. Extract fields for both merged and filtered VCFs
bcftools query -f '%CHROM\t%POS\t%ID\t%SVTYPE\t%SVLEN\t%END\t%SUPP\t%SUPP_VEC\n' $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".ready.vcf > $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".ready.table

# 2. 
Rscript 01_scripts/utils/summarize_plot_SVs.R $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".ready.table