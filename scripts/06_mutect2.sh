#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdir -p "${mutect2}" "${bqsr}"

echo "Variant calling START..........."

gatk Mutect2 --native-pair-hmm-threads "${THREADS}" -I "${bqsr}/${tumor}.bam"  -I "${bqsr}/${normal}.bam" -tumor "${tumor}" -normal "${normal}" -O "${mutect2}/."${tumor}".unfiltered.vcf.gz" -R "${ref}" -pon "${pon}" --germline-resource "${germline}"

echo "DONE"