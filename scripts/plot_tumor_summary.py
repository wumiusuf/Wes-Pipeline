import sys

import os

import pandas as pd

import matplotlib.pyplot as plt

results = sys.argv[1]   #result path

######################
# MUTATION SPECTRUM
######################

mut_spec = pd.read_csv(f"{results}/mutation_spectrum.tsv", sep="\t")
plt.figure()
plt.bar(mut_spec["Class"], mut_spec["Percent"])
plt.xlabel("Mutation Class")
plt.ylabel("Mutation Spectrum")
plt.tight_layout()
plt.savefig(f"{results}/mutation_spec.png", dpi=300)
plt.close()