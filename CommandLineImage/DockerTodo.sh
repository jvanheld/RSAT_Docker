#!/bin/bash
/rsat/perl-scripts/retrieve-seq  -org Saccharomyces_cerevisiae -feattype gene -type upstream -format fasta -label name -from -800 -to -1 -i /DockerIn/list.genes
