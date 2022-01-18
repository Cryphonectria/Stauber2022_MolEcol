## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 
## Proceeded on August 20, 2021 on LEG2 (script T. Badet)
## with RAiSD version 2.9
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 


## ## ## ## ## ## ## ## ## ## ## ## ## 
## run RAiSD on Ticino datasets

RAiSD -n Ticino_sampling1_run -f -y 1 -M 0 -w 50 -c 1 -I Ticino_sampling1.genotyped.SNP.filter.PASS.mac1.biallelic.DP.GQ.AD.removeMAT.recode.vcf
RAiSD -n Ticino_sampling2_run -f -y 1 -M 0 -w 50 -c 1 -I Ticino_sampling2.genotyped.SNP.filter.PASS.mac1.biallelic.DP.GQ.AD.removeMAT.recode.vcf

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### compute MS simulations given different models 
### fixed number of segregating sites

## run ms for bottleneck
ms 10 10000 -t 558 -r 0.0032457 12980 -eN .10000000000000000000 0.01 -s 412  > ms_strong_bottleneck_new.out
## expansion
ms 10 10000 -t 558 -r 0.0032457 12980 -eN .10000000000000000000 2 -s 2763 > ms_expansion_double_new.out
## neutral 
ms 10 10000 -t 558 -r 0.0032457 12980 -s 1581 > ms_neutral_new.out

## had to edit the resulting ms output files (remove "prob: -nan" lines) that weren't properly read by RaiSD

cat ms_strong_bottleneck_new.out | perl -pe 's/^prob.*\n//' > ms_strong_bottleneck_new_fixed.out
cat ms_expansion_double_new.out | perl -pe 's/^prob.*\n//' > ms_expansion_double_new_fixed.out
cat ms_neutral_new.out | perl -pe 's/^prob.*\n//' > ms_neutral_new_fixed.out

# run RAiSD
RAiSD -n ms_expansion_double_new_run -f -y 1 -L 7437273 -I ms_expansion_double_new_fixed.out
RAiSD -n ms_strong_bottleneck_new_run -f -y 1 -L 7437273 -I ms_strong_bottleneck_new_fixed.out
RAiSD -n ms_neutral_new_run -f -y 1 -L 7437273 -I ms_neutral_new_fixed.out

