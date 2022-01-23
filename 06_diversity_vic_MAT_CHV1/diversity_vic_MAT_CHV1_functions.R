## run permanova on ibs data

permanova_analysis <- function(vcf, popinfo, sampling) {
  
  require(SNPRelate)
  require(dplyr)
  require(vegan)
  
  if (sampling==1) {
    n <- 1
    samp <- "sampling1"
  } else {
    n <- 2
    samp <- "sampling2"
  }
  
  snpgds <- snpgdsVCF2GDS(vcf, paste0("Ticino_sampling", n, ".gds"), method="biallelic.only", ignore.chr.prefix = "scaffold_", verbose = F)
  
  genofile <- snpgdsOpen(snpgds)
  ibs <- snpgdsIBS(genofile, num.thread=4, verbose = F)
  mat <- data.matrix(ibs$ibs)
  showfile.gds(closeall=TRUE, verbose = F)
  rownames(mat) <- ibs$sample.id
  colnames(mat) <- ibs$sample.id
  ibs <- dist(mat, method = "euclidean")
  
  info <- filter(popinfo, pop==samp)
  
  #PERMANOVA
  adonis(ibs~info$vctype + info$MAT + info$Region + info$Virus, by="margin")
}


### return number of polymorphic vic loci per sampling and site
polymorphic_vic_fct <- function(dat) {
  vic <- c("vic1", "vic2", "vic3", "vic4", "vic6", "vic7")
  df <- data.frame(polymorphic=rep(NA, length(vic))) ## make empty df
  row.names(df) <- vic ## vic loci as row names
  
  for (i in vic) {
    is_polymorphic <- sum(!duplicated(dat[, i]))!=1 ## check if vic loci are polymorphic (i.e. alleles 1 and 2 present, or not)
    df[i,1] <- is_polymorphic ## append to empty data frame
    df$polymorphic <- ifelse(df$polymorphic == TRUE, 1, 0) ## transform TRUE=1, FALSE=0
    n_polymorphic <- sum(df$polymorphic)
  }
  return(n_polymorphic)
}
