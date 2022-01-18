# Stauber et al. 2022, Molecular Ecology - analysis pipeline

```00_rawdata_processing```:
* OS=CentOS 7.8, Queuing System=Slurm
* Install conda environment with ```conda env create -f environment.yaml --name popgenomics```
* Download SRA data to **00_rawdata**, e.g ```fastq-dump --split-files $SRR_ID --gzip --readids```
* Download files **Cryphonectria_parasiticav2.nuclearAssembly.unmasked** and **Cparasitica.mitochondria.fasta** from http://jgi.doe.gov/ to directory **01_REFgenome**
* Run Snakemake pipeline, e.g.: ```snakemake -c4```

```01_SNPassociations```: 
* Analysis mating type and vic loci associated SNPs

```02_popstructure```: 
* Analysis of population structure - DAPC, AMOVA and PCA 

```03_diversity_stats```: 
* Make summary statistics (number of SNPs, percent singletons, SNP density, nucleotide diversity)
* Calculate and plot allele frequencies and minor allele frequency (MAF) spectra of high, moderate and modifier impact mutations 

```04_IBS_IBD```:
* Calculating and plotting identity-by-state (IBS) and identity-by-descent (IBD), heatmaps and histograms
