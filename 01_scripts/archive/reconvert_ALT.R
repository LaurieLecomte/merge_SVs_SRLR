# 0. Access to files provided in command line arguments -------------------
argv <- commandArgs(T)
MERGED_VCF <- argv[1]            
LR_VCF <- argv[2] 
SR_VCF <- argv[3]
OUT_VCF <- argv[4]

# 1. Source required functions --------------------------------------------
source('01_scripts/utils/expl_ALT.R')

# 2. Process VCF ----------------------------------------------------
expl_ALT(merged_vcf = MERGED_VCF, 
        lr_vcf = LR_VCF,
        sr_vcf = SR_VCF,
        output_vcf = OUT_VCF
)