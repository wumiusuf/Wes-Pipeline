#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"		#root variable storage

mkdir -p "${aligned}" 					#output directory

echo "START"

bwa mem -t "${THREADS}" -R "@RG\tID:${tumor}\tSM:${tumor}\tPL:ILLUMINA" "${ref}" "${reads}/${tumor_read}_1.fastq.gz" "${reads}/${tumor_read}_2.fastq.gz" | samtools view -bS "${aligned}/${tumor}.unsorted.bam"

bwa mem -t "${THREADS}" -R "@RG\tID:${normal}\tSM:${normal}\tPL:ILLUMINA" "${ref}" "${reads}/${normal_read}_1.fastq.gz" "${reads}/${normal_read}_2.fastq.gz" | samtools view -bS "${aligned}/${normal}.unsorted.bam"

echo "DONE"