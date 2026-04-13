#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdir -p "${mutect2}" "${annotate_vcf}"

echo "START..........."

vep --dir_cache "${vep_cache}" -i "${mutect2}/${tumor}.filtered.vcf.gz" -o "${annotate_vcf}/${tumor}.annotate.vcf" --vcf --assembly GRCh38 --everything --fork "${THREADS}" --offline --force_overwrite

echo "DONE"
