#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdrir -p "${sorted}"

echo "START................."

samtools sort -@ "${THREADS}" -m 1G -o "${sorted}/${tumor}.sorted.bam" "${aligned}/${tumor}.unsorted.bam"

samtools sort -@ "${THREADS}" -m 1G -o "${sorted}/${normal}.sorted.bam" "${aligned}/${normal}.unsorted.bam"

echo "Sorting completed"

echo "Indexing Start........."

samtools index -@ "${THREADS}" "${sorted}/${tumor}.sorted.bam"

samtools index -@ "${THREADS}" "${sorted}/${normal}.sorted.bam"

echo "Indexing DONE"