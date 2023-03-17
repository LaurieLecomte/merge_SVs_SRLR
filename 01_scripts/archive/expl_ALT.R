# Main function -----------------------------------------------------------
expl_ALT <- function(merged_vcf, lr_vcf, sr_vcf, output_vcf) {
  
  options(scipen=999)
  
  # Opening a connection to read the vcf file
  input_con <- file(merged_vcf, open = "rt")
  on.exit(close(input_con), add = TRUE)
  
  # Opening another connection to the output file
  output_con <- file(output_vcf, open = "wt")
  on.exit(close(output_con), add = TRUE)
  
  # Lines are then used one by one to output the header
	while(grepl("^#", cur_line <- scan(input_con, what = character(), sep = "\n", n = 1, quiet = TRUE))) {
		cat(paste0(cur_line, "\n"), file = output_con)
	}
  
  # Read merged VCF
  vcf <- read.table(merged_vcf, comment.char = "#", stringsAsFactors = FALSE)
  #vcf <- vcf[, 1:8]
  #colnames(vcf) <- c('CHROM', 'POS', 'ID', 'REF', 'ALT', 'QUAL', 'FILTER', 'INFO')
  
  ## Extract SUPP_VEC from INFO
  supp_vecs <- as.character(sub(".*;SUPP_VEC=([0-9]+);.*", "\\1", vcf$V8))
  #ends <- ifelse(test = grepl("^END=", x = vcf$INFO),
  #               yes = as.integer(sub("^END=(-?[0-9]+).*", "\\1", vcf$INFO)),
  #               no = as.integer(sub(".*;END=(-?[0-9]+).*", "\\1", vcf$INFO))
  #)
  
  ## Deduct original ID before last merge from current ID
  pre_merge_IDs <- substr(x = vcf$V3, start = 3, stop = nchar(vcf$V3))
  
  # Read LR VCF 
  LR <- read.table(lr_vcf, comment.char = "#", stringsAsFactors = FALSE)
  LR <- LR[, 1:5]
  colnames(LR) <- c('CHROM', 'POS', 'ID', 'REF', 'ALT')
  

  # Read SR VCF 
  SR <- read.table(sr_vcf, comment.char = "#", stringsAsFactors = FALSE)
  SR <- SR[, 1:5]
  
  colnames(SR) <- c('CHROM', 'POS', 'ID', 'REF', 'ALT')
  #SR_ends <- ifelse(test = grepl("^END=", x = SR$INFO),
  #                  yes = as.integer(sub("^END=(-?[0-9]+).*", "\\1", SR$INFO)),
  #                  no = as.integer(sub(".*;END=(-?[0-9]+).*", "\\1", SR$INFO))
  #)
  
  # reassign explicit ALT from original VCF based on ID
  

  #REFs <- vector(mode = 'character', length = nrow(vcf))
  #ALTs <- vector(mode = 'character', length = nrow(vcf))
  
  #for (i in nrow(vcf)) {
  #  if (supp_vecs[i] == '11' ) {
  #    # extract ALT in LR vcf
  #    vcf$V5[i] <- LR$ALT[LR$ID == pre_merge_IDs[i] ]
  #    #ALTs[i] <- LR$ALT[LR$ID == pre_merge_IDs[i] ]
  #    # extract REF in LR vcf
  #    vcf$V4[i] <- LR$REF[LR$ID == pre_merge_IDs[i] ]
  #    #REFs[i] <- LR$REF[LR$ID == pre_merge_IDs[i] ]
  #  } else if (supp_vecs[i] == '10' ) {
  #  # extract ALT in LR vcf
  #    vcf$V5[i] <- LR$ALT[LR$ID == pre_merge_IDs[i] ]
  #    #ALTs[i] <- LR$ALT[LR$ID == pre_merge_IDs[i] ]
  #    # extract REF in LR vcf
  #    vcf$V4[i] <- LR$REF[LR$ID == pre_merge_IDs[i] ]
  #    #REFs[i] <- LR$REF[LR$ID == pre_merge_IDs[i] ]
  #  } else if (supp_vecs[i] == '01') {
  #    # extract ALT in SR vcf
  #    vcf$V5[i] <- SR$ALT[SR$ID == pre_merge_IDs[i] ]
  #    #ALTs[i] <- SR$ALT[SR$ID == pre_merge_IDs[i] ]
  #    # extract REF in LR vcf
  #    vcf$V4[i] <- SR$REF[SR$ID == pre_merge_IDs[i] ]
  #    #REFs[i] <- SR$REF[SR$ID == pre_merge_IDs[i] ]
  #  }
  #}
  all_seqs <- rbind(LR[, c('ID', 'REF', 'ALT')], SR[, c('ID', 'REF', 'ALT')])
  
  REFs <- sapply(X = pre_merge_IDs, FUN = function(x) {
    (all_seqs$REF[all_seqs$ID == x])
  })
  
  ALTs <- sapply(X = pre_merge_IDs, FUN = function(x) {
    (all_seqs$ALT[all_seqs$ID == x])
  })
  
  vcf$V4 <- REFs
  vcf$V5 <- ALTs
  
  # Writing the data.frame to the output file
  write.table(vcf, file = output_con, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE)
  
  # Writing
  return(invisible(NULL))
}