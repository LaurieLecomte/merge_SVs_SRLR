#!/bin/bash

# Merge SVs from both short and long reads with Jasmine
# Jasmine must be installed in current env or session

# valeria
# srun -c 1 --mem=100G -J 00_tmp_reformat -o log/00_tmp_reformat_%j.log /bin/sh 01_scripts/00_tmp_reformat.sh &

# manitou
# srun -c 1 --mem=100G -J 00_tmp_reformat -o log/00_tmp_reformat_%j.log /bin/sh 01_scripts/00_tmp_reformat.sh &
 
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



# 1. Reformat SR VCF

## Extract header
bcftools view -h $SR_VCF | grep ^'##' > $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".header
Rscript 01_scripts/utils/format_tmp_sym_ALT.R $SR_VCF $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".sym.contents

## Concatenate header and contents
cat $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".header $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".sym.contents > $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".symALT.vcf

# 2. Reformat LR VCF

## Extract header
bcftools view -h $LR_VCF | grep ^'##' > $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".header
Rscript 01_scripts/utils/format_tmp_sym_ALT.R $LR_VCF $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".sym.contents

## Concatenate header and contents
cat $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".header $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".sym.contents > $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".symALT.vcf

# Clean up 
rm $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".header
rm $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".sym.contents
rm $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".header
rm $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".sym.contents