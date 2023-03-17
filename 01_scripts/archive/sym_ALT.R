# Temporarily convert back ALT field to symbolic allele in order to reduce load on jasmine merging step

# Main function -----------------------------------------------------------
sym_ALT <- function(input_vcf, output_vcf) {
  
  # Opening a connection to read the vcf file
  input_con <- file(input_vcf, open = "rt")
  on.exit(close(input_con), add = TRUE)
  
  # Opening another connection to the output file
  output_con <- file(output_vcf, open = "wt")
  on.exit(close(output_con), add = TRUE)
  
  # Lines are then used one by one to output the header
	while(grepl("^#", cur_line <- scan(input_con, what = character(), sep = "\n", n = 1, quiet = TRUE))) {
		cat(paste0(cur_line, "\n"), file = output_con)
	}
  
  # Read VCF
  vcf <- read.table(VCF, comment.char = "#", stringsAsFactors = FALSE)
  
  # Extracting some useful information for each variant
  #chrs   <- vcf[[1]]
  #starts <- vcf[[2]]
  #altseq <- vcf[[5]]
  #refseq <- vcf[[4]]
  #svlen  <- as.integer(sub(".*SVLEN=(-?[0-9]+).*", "\\1", vcf[[8]]))
  # END field can be at the beginning or in the middle of INFO fields, so we need to extract accordingly
  #ends <- ifelse(test = grepl("^END=", x = vcf[[8]]),
  #             yes = as.integer(sub("^END=(-?[0-9]+).*", "\\1", vcf[[8]])),
  #             no = as.integer(sub(".*;END=(-?[0-9]+).*", "\\1", vcf[[8]]))
  #             )
  
  svtype <- sub(".*SVTYPE=([A-Z]+);.*", "\\1", vcf[[8]])
  
  #supps <- as.integer(sub(".*;SUPP=([0-9]+);.*", "\\1", vcf[[8]]))
  
  # Replace ALT field
  vcf[[5]] <- paste0('<', svtype, '>')
  
  # Replace REF field
  vcf[[4]] <- paste0('N')
  
  # Writing the data.frame to the output file
  write.table(vcf, file = output_con, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE)
  
  # Writing
  return(invisible(NULL))

}