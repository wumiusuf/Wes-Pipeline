#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdir -p "${mutect2}" "${bqsr}"

echo "START..........."

gatk GetPileupSummaries -I "${bqsr}/${tumor}.bam" -L "${small_exac}" -V "${small_exac}" -O "${mutect2}/${tumor}.pileups.table" -R "${ref}"

gatk GetPileupSummaries -I "${bqsr}/${normal}.bam" -L "${small_exac}" -V "${small_exac}" -O "${mutect2}/${normal}.pileups.table" -R "${ref}"

gatk CalculateContamination -I "${mutect2}/${tumor}.pileups.table" -matched "${mutect2}/${normal}.pileups.table" -0 "${mutect2}/${tumor}.contamination.table"

gatk FilterMutectCalls -R "${ref}" --contamination-table "${mutect2}/${tumor}.contamination.table" -V "${mutect2}/${tumor}.unfiltered.vcf.gz" -O "${mutect2}/${tumor}.filtered.vcf.gz"

echo "DONE"