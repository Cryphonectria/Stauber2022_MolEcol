## function to calculate IBS
IBS <- function(x)
{
  require(SNPRelate)
  # get short filename
  name <- gsub("\\.|\\/|data|.genotyped.SNP.filter.PASS.mac1.biallelic.DP.GQ.AD.removeMAT.recode.vcf", "", x)
  
  # run IBS analysis with SNPrelate
  vcf <- snpgdsVCF2GDS(x, name, method="biallelic.only", ignore.chr.prefix = "scaffold_", verbose = F)
  genofile <- snpgdsOpen(vcf)
  ibs <- snpgdsIBS(genofile, num.thread=4, verbose = F)
  mat <- data.matrix(ibs$ibs)
  rownames(mat) <- ibs$sample.id
  colnames(mat) <- ibs$sample.id
  showfile.gds(closeall=TRUE, verbose = F)
  
  # convert mat into dataframe
  df <- as.data.frame(mat)
  df <-reshape2::melt(as.matrix(df))
  df$sampling <- name
  names(df)[c(1, 2, 3)] <- c("sample1", "sample2", "IBS")
  
  return(df)
}

