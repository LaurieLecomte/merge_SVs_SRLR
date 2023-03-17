#!/bin/bash

# Merge SVs from both short and long reads with Jasmine
# Jasmine must be installed in current env or session

# valeria
# srun -c 10 -p ibis_medium --time=3-00:00:00 --mem=200G -J 01_merge_SRLR_unformatted -o log/01_merge_SRLR_unformatted_%j.log /bin/sh 01_scripts/01_merge_SRLR_unformatted.sh &

# manitou
# srun -c 10 -p medium --time=3-00:00:00 --mem=200G -J 01_merge_SRLR_unformatted -o log/01_merge_SRLR_unformatted_%j.log /bin/sh 01_scripts/01_merge_SRLR_unformatted.sh &
 
# VARIABLES
GENOME="03_genome/genome.fasta"
VCF_DIR="04_vcf"
MERGED_DIR="05_merged"
FILT_DIR="06_filtered"

SR_VCF="$VCF_DIR/SR/merged_delly_manta_smoove_SUPP2.vcf"
LR_VCF="$VCF_DIR/LR/merged_sniffles_svim_nanovar_SUPP2_unformatted.vcf"

VCF_LIST="02_infos/VCFs_unformatted.txt"
MERGED_VCF="$MERGED_DIR/merged_SUPP2_unformatted.vcf"

REGIONS_EX="02_infos/excl_chrs.txt"

CPU=10


# 0. Remove VCF list from previous trials if any
if [[ -f $VCF_LIST ]]
then
  rm $VCF_LIST
fi

# 1. List all merged VCFs
echo $LR_VCF > $VCF_LIST
echo $SR_VCF >> $VCF_LIST


# 2. Merge SV calls accross samples, using predefined parameters (same as merging for the 3 short reads callers)
#jasmine file_list=$VCF_LIST out_file=$MERGED_VCF out_dir=$MERGED_UNION_DIR genome_file=$GENOME --ignore_strand --ignore_merged_inputs --normalize_type --output_genotypes --allow_intrasample --mutual_distance --max_dist_linear=0.25 --threads=$CPU

jasmine file_list=$VCF_LIST out_file=$MERGED_VCF out_dir=$MERGED_DIR genome_file=$GENOME --ignore_strand --ignore_merged_inputs --normalize_type --output_genotypes --threads=$CPU