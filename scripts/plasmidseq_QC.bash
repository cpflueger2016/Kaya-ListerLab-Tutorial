#!/bin/bash

### Plasmid-Seq quality reporter script ###

### Variable
mappedPlasmidFolder=$1
threads=$2
current_date=$(date +%Y-%m-%d)

### Inventory of all bam files ###
find "${mappedPlasmidFolder}" -name "*.bam" -a -not -name "*unmapped*" -exec realpath {} >> bam_files.txt \;

### Compute Sequencing Stats ###
parallel -j $threads 'samtools stats -@ 2 "{}" > "{.}"_seqStats.log' :::: bam_files.txt

### Collect Sequencing Stats ###
find "${mappedPlasmidFolder}" -name "*_seqStats.log" -exec realpath {} >> bam_sample_seqStats.log  \;

### Give sensible names to the samples
while read line; do \
	sample=$(basename $line | sed 's/_seqStats\.log//'); \
	echo -ne "$line\t$sample\n" >> sample_names.tsv; \
done < bam_sample_seqStats.log

### Combine all the seq stats with multiqc ###
multiqc -l bam_sample_seqStats.log \
--replace-names sample_names.tsv \
-o PlasmidSeq_Stats_QC \
--title PlasmidSeq Stats ${current_date} 