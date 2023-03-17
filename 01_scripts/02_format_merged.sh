#!/bin/bash

# Format merged output
# Jasmine must be installed in current env or session

# valeria
# srun -c 1 -p ibis_small --time=1-00:00:00 --mem=50G -J 02_format_merged -o log/02_format_merged_%j.log /bin/sh 01_scripts/02_format_merged.sh &

# manitou
# srun -c 1 -p small --time=1-00:00:00 --mem=50G -J 02_format_merged -o log/02_format_merged_%j.log /bin/sh 01_scripts/02_format_merged.sh &
 
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

# 1. Correct fields 
## Remove STRANDS (otherwise usual bcftools commands will not work because not defined in header)
sed -E "s/\;STRANDS\=\?\?//"  $MERGED_VCF > $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".tmp 

## Remove all optional fields added by Jasmine and Iris and sort
bcftools annotate -x ^INFO/SVTYPE,INFO/SVLEN,INFO/END,INFO/SUPP,INFO/SUPP_VEC $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".tmp > $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".ready.vcf

# Clean up
rm $FILT_DIR/"$(basename -s .vcf $MERGED_VCF)".tmp