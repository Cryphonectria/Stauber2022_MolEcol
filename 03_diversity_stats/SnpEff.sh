ANALYSISHOME=~/Documents/Analysis/RawData 	
cd $ANALYSISHOME
# SNPeff for Cryphonectria

## build SnpEff database

## files:

# Cparasiticav2.GeneCatalog20091217.17Jan2019.gff3
# Cryphonectria_parasiticav2.nuclearAssembly.unmasked.fa --> rename to cpv2


#edit config file
mate /usr/local/Cellar/snpeff/4.3t/share/snpeff/snpEff.config 


# add the following two lines
# Cryphonectria parasitica v2 JGI
cpv2.genome : Cryphonectria parasitica



# copy genome

cd /usr/local/Cellar/snpeff/4.3t/share/snpeff/data 
mkdir genomes
cd genomes



#gff to gtf conversion, copying
cd /usr/local/Cellar/snpeff/4.3t/share/snpeff/data 

mkdir cpv2
cd cpv2



gffread ~/Desktop/Cparasiticav2.GeneCatalog20091217.17Jan2019.gff3 -T -o genes.gtf

snpEff build -gtf22 -v cpv2 > snpEff.build.log.txt



java -jar /Users/stauber/software/snpEff/snpEff.jar build -gtf22 -v cpv2 > snpEff.build.log.txt



### run SNPeff
cd /usr/local/Cellar/snpeff/4.3t/share/snpeff
java -jar /Users/stauber/software/snpEff/snpEff.jar -v $output.html cpv2 $vcf > $vcf_annotated

