# Merge SVs called from both short and long-read data

## TO DO
* Load required modules outside of scripts and correct versions for both manitou and valeria 

## Pipeline Overview

1. **Merge** calls : `01_merge_SRLR.sh`
2. **Format** merged output : `02_format_merged.sh` 

## Prerequisites

### Files

* SR VCF : The output VCF from the [SVs_SR_pipeline](https://github.com/LaurieLecomte/SVs_short_reads) 
* LR VCF : The output VCF from the [SVs_LR_pipeline](https://github.com/LaurieLecomte/SVs_long_reads) 
* A reference genome named `genome.fasta` and its index (.fai) in `03_genome`


### Software

#### For Manitou and Valeria users
Install Jasmine in a conda env and load this env prior to running this pipeline.

 
