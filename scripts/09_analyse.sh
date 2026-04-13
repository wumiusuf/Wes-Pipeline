#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdir -p "${annotate_vcf}" "${results}"

echo "START.........."

bgzip -f "${annotate_vcf}/${tumor}.annotate.vcf" 					#compress vcf

tabix  -f -p vcf "${annotate_vcf}/${tumor}.annotate.vcf.gz"			#index vcf

echo "Total Variants: $(bcftools view -H ${annotate_vcf}/${tumor}.annotate.vcf.gz | wc -l)" >> "${results}/variant_summary.txt" 

echo "PASS Variants: $(bcftools view -H -f PASS ${annotate_vcf}/${tumor}.annotate.vcf.gz | wc -l)" >> "${results}/variant_summary.txt"

echo "Total SNPs: $(bcftools view -H -v snps ${annotate_vcf}/${tumor}.annotate.vcf.gz | wc -l)" >> "${results}/variant_summary.txt"

echo "Total INDELS: $(bcftools view -H -v indels ${annotate_vcf}/${tumor}.annotate.vcf.gz | wc -l)" >> "${results}/variant_summary.txt"


#############################
# Mutation Spectrum Analysis
#############################

bcftools view -f PASS -v snps "${annotate_vcf}/${tumor}.annotate.vcf.gz" \
  | bcftools query -f '%REF>%ALT\n' \
  | sort | uniq -c | sort -nr > "${results}/mutation_raw.txt"

awk '
{count[$2]=$1} 
END{
	CTA = count["C>T"] + count["G>A"]
	CGA = count["C>G"] + count["G>C"]
	CAA = count["C>A"] + count["G>T"]
	TCA = count["T>C"] + count["A>G"]
	TAA = count["T>A"] + count["A>T"]
	TGA = count["T>G"] + count["A>C"]

	total = CTA + CGA + CAA + TCA + TAA + TGA

	printf "Class\tCount\tPercent\n"

	printf "C>T\t%d\t%.2f\n", CTA, (CTA/total)*100
	printf "C>G\t%d\t%.2f\n", CGA, (CGA/total)*100
	printf "C>A\t%d\t%.2f\n", CAA, (CAA/total)*100
	printf "T>C\t%d\t%.2f\n", TCA, (TCA/total)*100
	printf "T>A\t%d\t%.2f\n", TAA, (TAA/total)*100
	printf "T>G\t%d\t%.2f\n", TGA, (TGA/total)*100
}
' "${results}/mutation_raw.txt" > "${results}/mutation_spectrum.tsv"

python "${scripts}/plot_tumor_summary.py" "${results}" "${annotate_vcf}"

echo "DONE"

