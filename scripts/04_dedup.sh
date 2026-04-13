#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

mkdir -p "${dedup}"

echo "START............"

picard MarkDuplicates -I "${sorted}/${tumor}.sorted.bam" -M "${dedup}/${tumor}.dedup.txt" -O "${dedup}/${tumor}.dedup.bam" --CREATE_INDEX true

picard MarkDuplicates -I "${sorted}/${normal}.sorted.bam" -M "${dedup}/${normal}.dedup.txt" -O "${dedup}/${normal}.dedup.bam" --CREATE_INDEX true

echo "DONE"