"""High Impact Variant Parser
======================
To extract only clinically significant oncology genes from Cannonical Filtered variant file

Input : PASSED variants filtered by cannonical consequences

Output : CSV of high/moderate impact variant

Filtering Logic:

-TSO_500 gene panel only (source: ILLUMINA
                            http: https://www.illumina.com/content/dam/illumina-marketing/documents/products/gene_lists/gene_list_trusight_oncology_500%20ctDNA%20with%20fusions.xlsx)

-IMPACT (HIGH and MODERATE)

-Clinically relevant consequenc type (CSQ: missense_variant, stop_gained, frameshift_variant, splice_donor_variant, splice_acceptor_variant, start_lost)

Classification:

-Clonality Logic using Tumor Allele Frequency

-Germline contamination using Normal Allele Frequncy

Author: Omowumi Anjorin

Date: April 2026

"""

######################################################################
# STEP 1: READ ILLUMINA TSO_500 EXEL FILE AND EXTRACT ONLY GENE SYMBOL
# ####################################################################

import pandas as pd
import numpy as np

tso = pd.read_excel("/Users/wumia/Downloads/gene_list_trusight_oncology_500 ctDNA with fusions.xlsx", header=2, sheet_name=0, usecols="A", na_values="Total")

tso_genes = set(tso["Gene symbol"].dropna())        #convert df to set and drop na values

#read cannonical. variant list and filter using tso gene panel

##################################################################################################
# STEP 2: FILTER CANONICAL VARIANT LIST USING TSO_500 PANEL FOR ONLY CLINICALLY SIGNIFICANT GENES
##################################################################################################

variants = pd.read_csv("/Users/wumia/Downloads/can_variants.tsv", sep="\t", skipinitialspace=True)
filter_tso = variants[variants["SYMBOL"].isin(tso_genes)]

##################################################################
#STEP 3: FILTER BY IMPACT FOR ONLY HIGH IMPACT AND MODERATE GENES 
##################################################################

filter_impact = filter_tso[filter_tso["IMPACT"].isin(["HIGH", "MODERATE"])]

#######################
#STEP 4: FILTER BY CSQ 
#######################

filter_csq = filter_impact[filter_impact["CSQ"].isin(["missense_variant" , "stop_gained", "frameshift_variant", "splice_donor_variant", "splice_acceptor_variant", "start_lost"])]

#########################################################
#STEP 5: ASSIGN COLUMNS FOR CLONALITY CLASSIFICATION
#########################################################

clonality = filter_csq.assign(
    Clonality=lambda x: np.where(x["Tumor_AF"] >= 0.4, "clonal",
                        np.where((x["Tumor_AF"] >= 0.1) & (x["Tumor_AF"] < 0.4), "subclonal",
                        "low-level"))
)

####################################################
#STEP 6: ASSIGN COLUMNS FOR GERMLINE CONTAMINATION
####################################################

germline = clonality.assign(
    Contamination=lambda x: np.where(x["Normal_AF"] >= 0.02, "gernline_contamination", "N/A"))

#####################################
#STEP 7: WRITE FINAL OUTPUT TO CSV
#####################################

germline.to_csv("/Users/wumia/Downloads/clin_var_summary.csv", sep=",", mode="w", index=False)