#!/bin/bash

# Merge SVs from both short and long reads with Jasmine
# Jasmine must be installed in current env or session  

# valeria
# srun -c 10 -p ibis_medium --time=3-00:00:00 --mem=100G -J 01_merge_SRLR_reconvert -o log/01_merge_SRLR_reconvert_%j.log /bin/sh 01_scripts/01_merge_SRLR_reconvert.sh &

# manitou
# srun -c 20 -p medium --time=3-00:00:00 --mem=100G -J 01_merge_SRLR_reconvert -o log/01_merge_SRLR_reconvert_%j.log /bin/sh 01_scripts/01_merge_SRLR_reconvert.sh &
 
# VARIABLES
GENOME="03_genome/genome.fasta"
VCF_DIR="04_vcf"
MERGED_DIR="05_merged"
FILT_DIR="06_filtered"

SR_VCF="$VCF_DIR/SR/merged_delly_manta_smoove_SUPP2.vcf"
LR_VCF="$VCF_DIR/LR/merged_sniffles_svim_nanovar_SUPP2.vcf"

VCF_LIST="02_infos/VCFs.sym.txt"
MERGED_VCF="$MERGED_DIR/merged_SUPP2_ALTreconvert.vcf"

REGIONS_EX="02_infos/excl_chrs.txt"

CPU=20


# 0. Remove VCF list from previous trials if any
if [[ -f $VCF_LIST ]]
then
  rm $VCF_LIST
fi

# 1. Replace REF and ALT seqs in 2 VCFs to reduce load for merging step
## for SR
Rscript 01_scripts/utils/format_tmp_sym_ALT.R $SR_VCF $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".sym.vcf
## for LR
Rscript 01_scripts/utils/format_tmp_sym_ALT.R $LR_VCF $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".sym.vcf

# 2. List the 2 simplified VCFs
echo $VCF_DIR/LR/"$(basename -s .vcf $LR_VCF)".sym.vcf > $VCF_LIST
echo $VCF_DIR/SR/"$(basename -s .vcf $SR_VCF)".sym.vcf >> $VCF_LIST



# 2. Merge the 2 simplified VCFs, using predefined parameters (same as merging for the 3 short reads callers)
#jasmine file_list=$VCF_LIST out_file=$MERGED_VCF out_dir=$MERGED_UNION_DIR genome_file=$GENOME --ignore_strand --ignore_merged_inputs --normalize_type --output_genotypes --allow_intrasample --mutual_distance --max_dist_linear=0.25 --threads=$CPU

jasmine file_list=$VCF_LIST out_file=$MERGED_DIR/merged_SUPP2.sym.vcf out_dir=$MERGED_DIR genome_file=$GENOME --ignore_strand --ignore_merged_inputs --normalize_type --output_genotypes --threads=$CPU

# 3. Reconvert REF and ALT to their explicit sequences based on the 2 input VCFs
Rscript 01_scripts/utils/reconvert_ALT.R $MERGED_DIR/merged_SUPP2.sym.vcf $LR_VCF $SR_VCF $MERGED_VCF