#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdir -p "${bqsr}"


echo "START........."

gatk BaseRecalibrator -I "${dedup}/${tumor}.dedup.bam" --known-sites "${known_sites_1}" --known-sites "${known_sites_2}" --known-sites "${known_sites_3}" -O "${bqsr}/${tumor}.table" -R "${ref}" 

gatk BaseRecalibrator -I "${dedup}/${normal}.dedup.bam" --known-sites "${known_sites_1}" --known-sites "${known_sites_2}" --known-sites "${known_sites_3}" -O "${bqsr}/${normal}.table" -R "${ref}" 

echo "DONE"

echo "Phase 2 START apply bqsr........."

gatk ApplyBQSR --bqsr-recal-file "${bqsr}/${tumor}.table" -I "${dedup}/${tumor}.dedup.bam" -O "${bqsr}/${tumor}.bam" -R "${ref}"

gatk ApplyBQSR --bqsr-recal-file "${bqsr}/${normal}.table" -I "${dedup}/${normal}.dedup.bam" -O "${bqsr}/${normal}.bam" -R "${ref}"

echo "DONE"