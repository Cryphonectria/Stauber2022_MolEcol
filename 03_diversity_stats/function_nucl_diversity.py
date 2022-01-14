# import library
import pandas as pd
import glob
import re

# function that takes files in a folder and calculate a df with pi
def calculate_nuc_diversity():
    # get file name
    Population_name = glob.glob("./*.sites.pi")
    #Population_name_simple = ([s.replace('../vcftools_pi_haploid/', '') for s in Population_name])
    #print(Population_name)
    #print(Population_name_simple)
    
    # define data frame
    df_Nuc_diversity_pnod = pd.DataFrame(columns=["PopID", "Genome_size", "Number_of_snps", "PI_from_snps", "factor", "final_genomewide_pi"])
    
    for index, item in enumerate(Population_name):
        #print(f"This is population number {index} named {item}")
        #print(item)
        
        # define population name
        Population_name_simple = re.sub("./vcftools_pi_haploid/", "", item)
        #print(Population_name_simple)

        # load df
        df_pi = pd.read_csv(item, sep="\t")
        #print(df_pi.head())

        # exclude rows with 0 in PI
        df_pi = df_pi[df_pi.PI != 0]
        #print(df_pi.head())

        # get length of df (this is equivalent to number of SNPs)
        Number_of_SNPS = len(df_pi.index)
        #print(Number_of_SNPS)

        # fixed attribute for genome size of C. parasitica (derived from Cryphonectria_parasiticav2.fa.fai REfgenome)
        Genome_size = 44029313

        # divide genome length by number of snps
        Factor_pi = Genome_size / Number_of_SNPS
        Factor_pi

        # get average pi
        Mean_pi_raw = df_pi["PI"].mean()
        Mean_pi_raw

        # get final pi
        Final_nucl_diversity = Mean_pi_raw / Factor_pi
        #print(Final_nucl_diversity)

        # list for final df
        Current_list_nuc_div = [Population_name_simple, Genome_size, Number_of_SNPS, Mean_pi_raw, Factor_pi, Final_nucl_diversity]
        #print(Current_list_nuc_div)

        # new list to a row 
        new_row = pd.Series({"PopID":Population_name_simple, "Genome_size":Genome_size, "Number_of_snps":Number_of_SNPS, "PI_from_snps":Mean_pi_raw, "factor":Factor_pi, "final_genomewide_pi":Final_nucl_diversity})
        print(new_row)

        # add new row to df
        df_Nuc_diversity_pnod.loc[index] = new_row

    # out of the loop, but within function, save the result to a file
    df_Nuc_diversity_pnod.to_csv("./Final_nuc_diversity.txt", index = False, sep="\t")

calculate_nuc_diversity()
