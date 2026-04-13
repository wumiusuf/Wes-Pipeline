#!/usr/bin/env bash


set -euo pipefail				#set end of pipeline fail 

source "$(dirname "$0")/config.sh" 

mkdir -p "${read_qc}" 			#output directory

echo "START..........."

fastqc "${reads}"/*fastq.gz -t "${THREADS}" -o "${read_qc}"


echo "DONE"
