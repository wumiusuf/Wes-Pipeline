#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/config.sh"

scripts_dir="$(dirname "$0")"

echo "START wes pipeline"

bash "${scripts_dir}/01_fastqc.sh"

bash "${scripts_dir}/02_align.sh"

bash "${scripts_dir}/03_sort_index.sh"

bash "${scripts_dir}/04_dedup.sh"

bash "${scripts_dir}/05_bqsr.sh"

bash "${scripts_dir}/06_mutect2.sh"

bash "${scripts_dir}/07_filter_contamination.sh"

bash "${scripts_dir}/08_vep.sh"

bash "${scripts_dir}/09_analyse.sh"

echo "PIPELINE completed"