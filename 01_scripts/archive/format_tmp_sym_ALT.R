# 0. Access to files provided in command line arguments -------------------
argv <- commandArgs(T)
VCF <- argv[1]            # original, unformatted vcf, can be gzipped
formatted_VCF <- argv[2]  # output vcf, will be overwritten

# 1. Source required functions --------------------------------------------
source('01_scripts/utils/sym_ALT.R')

# 2. Process VCF ----------------------------------------------------
sym_ALT(input_vcf = VCF, 
        output_vcf = formatted_VCF
        )