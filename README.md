# Wes-Somatic Variant Calling Pipeline

## Overview
End-to-end somatic variant calling pipeline for matched tumour-normal whole exome sequencing (WES) analysis. Built and validated using HCC1395 breast cancer cell line with matched normal (HCC1395BL) 

## Dataset
- **Tumor:**  HCC1395 (breast adenocarcinoma cell line)
- **Normal:**  HCC1395BL (matched normal)
- **Source:**  NCBI SRA (SRR7890848, SRR7890874)
- **Reference genome:**  GRCh38/hg38
- **Known sites:**  dbSNP138, 1000G known indels, 1000G omni2.5
- **Panel of Normals:**  1000G PON (GATK best practices)
- **Germline resource:**  gnomAD af-only hg38

## Pipeline Steps
| Step | Tool | Version |
|------|------|---------|
| Quality Control | FastQC | 0.12.1 |
| Alignment | BWA-MEM | 0.7.19 |
| Alignment Sorting/Indexing | Samtools | 0.1.19-96b5f2294a
| Duplicate Marking | Picard MarkDuplicates | 3.4.0 |
| Base Recalibration | GATK BaseRecalibrator/ApplyBQSR | 4.6.2.0 |
| Variant Calling | GATK Mutect2 | 4.6.2.0 |
| Contamination Estimation | GATK CalculateContamination | 4.6.2.0 |
| Variant Filtering | GATK FilterMutectCalls | 4.6.2.0 |
| Variant Annotation | Ensembl VEP | 115.2 |
| Analysis/Filtering | bcftools | 1.20 |

## Requirements
- BWA 0.7.19
- GATK 4.6.2.0
- Picard 3.4.0
- Ensembl VEP 115.2
- bcftools 1.20
- FastQC 0.12.1
- Python 3.13.5 
- samtools 0.1.19-96b5f2294a


## Key Findings
- **TP53 p.R175H** — known hotspot missense mutation, pathogenic 
  (ClinVar), DNA binding domain, consistent with known HCC1395 profile
- **BRCA2 p.Glu1593Ter** — truncating stop gained variant, 
  HIGH impact, loss of function


## Author
Omowumi Yusuf  
Assay Development Scientist | Clinical Bioinformatics    

