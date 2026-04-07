"""VCF Clinical Variant Summary Parser
=======================================
Extract Clinically relevant variant from an Ensembl VEP-annotated
somatic VCF (GATK Mutect2 tumor-normal WES output - single sample)

Input: VEP-annotated VCF(--everything flag)gzip compressed

Output: TSV with one row per PASSED variant, canonical transcript only

Filtering logic:
-PASS variant only (Mutect2 somatic filter)
-Canonical Transcript only (Ensembl primary transcript per gene)

Output Fields:
-CHROM, POS, REF, ALT: genomic coordinates
-SYMBOL, CSQ, IMPACT, HGVSp: biological annotation (VEP CSQ Field)
-SIFT, PolyPhen: in silico pathogenicity predictions
-tumor_AF, tumor_DP: tumor allele frequency and depth (Format field)
-normal_AF, normal_DP: normal allele frequency and depth for comparison

Author: Omowumi Anjorin

Date: April 2026"""

import gzip
#variables required
metadata = "" #saved as string, headers always accesible using bcftools
header = []                 #header columns in file
variants = []               #all variant list
filter_var = []             #only passed variant list
non_pass = []               #failed variants list
index_list = []             #per variant index
index_list_info = []        #per variant index info field  
can_var = []                #canonical flag variants summary

with gzip.open("/Users/wumia/Downloads/filtered.annotate.vcf.gz", "r") as vcf:
    for line in vcf:
        lines = line.strip()
        if lines.startswith(b"##"):
            metadata = lines
        elif lines.startswith(b"#"):
            lines = lines[1:]
            header = lines.split(b"\t")
        else:
            variants = lines.decode("utf-8").split("\t")
            if variants[6] == "PASS":
                #select only passed variant                
                filter_var.append(variants)
            else:
                non_pass.append(variants)

#################################################################################
# # PHASE 2 - Index filtering and extraction of variants (primary transcripts only)
# ##################################################################################
for values in range(len(filter_var)):               #get indexes of all variant in list of list    
    index_list = filter_var[values]                 #split INFO FIELD using colon to find Consequences (CSQ)    
    index_list_info = index_list[7].split(";")      
    #CSQ contains VEP annotation for all overlapping transcripts    
    # comma-separated, each transcript pipe-deliminated    
    for element in index_list_info:
        if element.startswith("CSQ="):
            csq_list = element.split(",")
            for i in csq_list:
                transcript = i.split("|") 
                #canonical field for primary transcripts only                
                if transcript[24] == "YES":
                    CHROM = index_list[0] 
                    POS = index_list[1] 
                    REF = index_list[3]
                    ALT = index_list[4] 
                    CSQ = transcript[1] 
                    IMPACT = transcript[2]
                    SYMBOL = transcript[3]
                    HGVSp = transcript[11]
                    SIFT = transcript[38]
                    PolyPhen = transcript[39]
                    format = index_list[8].split(":")
                    tumor = index_list[9].split(":")
                    normal = index_list[10].split(":") 
                    Tumor_AF = tumor[2]
                    Tumor_DP = tumor[3] 
                    Normal_AF = normal[2]
                    Normal_DP = normal[3]
                    row = [CHROM, POS, REF, ALT, SYMBOL, CSQ, IMPACT, HGVSp, SIFT, PolyPhen, Tumor_AF, Tumor_DP, Normal_AF, Normal_DP] 
                    can_var.append(row)

############################################## 
# PHASE 3 - write output into TSV file Index 
# #############################################
#use row variables as headers
tsv_headers = "CHROM, POS, REF, ALT, SYMBOL, CSQ, IMPACT, HGVSp, SIFT, PolyPhen, Tumor_AF, Tumor_DP, Normal_AF, Normal_DP"
new_headers = tsv_headers.split(",")

with open("/Users/wumia/Downloads/can_variants.tsv", "w")as out:
    out.write("\t".join(new_headers) + "\n")
    for row in can_var:
        out.write("\t".join(row) + "\n")