#!/usr/bin/env bash 


ref="/Volumes/ssd/bioinformatics_workshop/genomes/hg38"  				#reference fasta hg38 directory

project_dir="/Volumes/ssd/bioinformatics_workshop/wes/hcc1395/wes_hcc1395"		#root directory for wes HCC1395 pipeline

resources="$project_dir/resources"									#know sites resources

vep_cache="${resources}/vep_cache/homo_sapiens/115_GRCh38" 			#ensemblvep cache

tumor="HCC1395" 			#tumor cell line ID

normal="HCC1395BL"		#normal cell line ID

THREADS=6 				#thread for use

tumor_read="SRR7890848"    #tumor read
normal_read="SRR7890874"	#normal read

known_sites_1="$resources/Homo_sapiens_assembly38.dbsnp138.vcf.gz" 				#dbsnp variants for bqsr
known_sites_2="$resources/Homo_sapiens_assembly38.known_indels.vcf.gz"			#indels variants for bqsr
known_sites_3="$resources/1000G_omni2.5.hg38.vcf.gz"
pon="$resources/1000g_pon.hg38.vcf.gz"											#pon for mutect2 calling
germline="$resources/af-only-gnomad.hg38.vcf.gz"								#germline variants for mutect2 calling
small_exac="$resources/small_exac_common_3.hg38.vcf.gz"							#for creating mpileup for mutect2


#create sub directories needed for each analysis output
reads="${project_dir}/reads"
read_qc="${project_dir}/read_qc"
aligned="${project_dir}/aligned"
bqsr="${project_dir}/bqsr"
dedup="${project_dir}/dedup"
sorted="${project_dir}/sorted"
scripts="${project_dir}/scripts"
annotate_vcf="${project_dir}/annotate_vcf"
mutect2="${project_dir}/mutect2"
results="${project_dir}/results"
logs="${project_dir}/logs"

