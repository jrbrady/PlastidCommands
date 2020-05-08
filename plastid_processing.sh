module add python/2.7.13
module add plastid/0.4.8

#Manipulate Annotations

reformat_transcripts --annotation_files phaffii_WT.P4.P6.Cere.sorted.gtf --annotation_format GTF2 --sorted --extra_columns gene_id Notes --output_format BED phaffii_WT.P4.P6.Cere.sorted.extended.bed

bedSort phaffii_WT.P4.P6.Cere.sorted.extended.bed phaffii_WT.P4.P6.Cere.sorted.extended.bed 
bedToBigBed -tab -type=bed12+2 -extraIndex=name,gene_id -as=my_fields.as phaffii_WT.P4.P6.Cere.sorted.extended.bed WT_P4_P6_Cere.sizes phaffii_WT.P4.P6.Cere.bb

crossmap -k 25 --mismatches 2 --bowtie bowtie --sequence_file WT_P4_P6_Cere.fasta WT_P4_P6_Cere WT_P4_P6_Cere.crossmap

bedToBigBed WT_P4_P6_Cere.crossmap_25_2_crossmap_sorted.bed WT_P4_P6_Cere.crossmap_25_2_crossmap.sizes WT_P4_P6_Cere.crossmap_25_2_crossmap_sorted.bb
bedSort WT_P4_P6_Cere.crossmap_25_2_crossmap.bed WT_P4_P6_Cere.crossmap_25_2_crossmap_sorted.bed

#Offsets, Phasing and StartCodons
metagene generate --annotation_files phaffii_WT.P4.P6.Cere.sorted.gtf --mask_annotation_files WT_P4_P6_Cere.crossmap_25_2_crossmap_sorted.bb --mask_annotation_format BigBed --landmark cds_start --upstream 25 --downstream 200 WT_P4_P6_Cere.starts

psite WT_P4_P6_Cere.starts_rois.txt P4offsets --min_length 26 --max_length 31 --require_upstream --count_files ../star_combo_no_rDNA/d1650_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam
psite WT_P4_P6_Cere.starts_rois.txt P6offsets --min_length 26 --max_length 31 --require_upstream --count_files ../star_combo_no_rDNA/d1651_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam
psite WT_P4_P6_Cere.starts_rois.txt Cereoffsets --min_length 25 --max_length 30 --require_upstream --count_files ../star_combo_no_rDNA/d1652_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam

phase_by_size WT_P4_P6_Cere.starts_rois.txt P4phasing --count_files ../star_combo_no_rDNA/d1650_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P4offsets_edited.txt --min_length 26 --max_length 31
phase_by_size WT_P4_P6_Cere.starts_rois.txt P6phasing --count_files ../star_combo_no_rDNA/d1651_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P6offsets_edited.txt --min_length 26 --max_length 31
phase_by_size WT_P4_P6_Cere.starts_rois.txt Cerephasing --count_files ../star_combo_no_rDNA/d1652_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset Cereoffsets_edited.txt --min_length 25 --max_length 30

metagene count WT_P4_P6_Cere.starts_rois.txt P4starts --count_files ../star_combo_no_rDNA/d1650_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P4offsets_edited.txt \
--normalize_over 30 200 --min_counts 100 \
--cmap Blues --title "P4_starts"

metagene chart P4starts P4starts_metagene_profile.txt --landmark "start codon" --title "P4starts"

metagene count WT_P4_P6_Cere.starts_rois.txt P6starts --count_files ../star_combo_no_rDNA/d1651_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P6offsets_edited.txt \
--normalize_over 30 200 --min_counts 100 \
--cmap Blues --title "P6_starts"

metagene chart P6starts P4starts_metagene_profile.txt --landmark "start codon" --title "P6starts"

metagene count WT_P4_P6_Cere.starts_rois.txt Cerestarts --count_files ../star_combo_no_rDNA/d1652_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset Cereoffsets_edited.txt \
--normalize_over 30 200 --min_counts 100 \
--cmap Blues --title "Cere_starts"

metagene chart Cerestarts Cerestarts_metagene_profile.txt --landmark "start codon" --title "Cerestarts"

###StopCodon Work
metagene generate --annotation_files phaffii_WT.P4.P6.Cere.sorted.gtf --mask_annotation_files WT_P4_P6_Cere.crossmap_25_2_crossmap_sorted.bb --mask_annotation_format BigBed --landmark cds_stop --upstream 50 --downstream 10 WT_P4_P6_Cere.stops

metagene count WT_P4_P6_Cere.stops_rois.txt P4stops --count_files ../star_combo_no_rDNA/d1650_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P4offsets_edited.txt \
--normalize_over -50 0 --min_counts 100 \
--cmap Blues --title "P4_stops"

metagene chart P4stops P4stops_metagene_profile.txt --landmark "stop codon" --title "P4stops"

metagene count WT_P4_P6_Cere.stops_rois.txt P6stops --count_files ../star_combo_no_rDNA/d1651_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P6offsets_edited.txt \
--normalize_over -50 0 --min_counts 100 \
--cmap Blues --title "P6_stops"

metagene chart P6stops P6stops_metagene_profile.txt --landmark "stop codon" --title "P6stops"

metagene count WT_P4_P6_Cere.stops_rois.txt Cerestops --count_files ../star_combo_no_rDNA/d1652_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset Cereoffsets_edited.txt \
--normalize_over -50 0 --min_counts 100 \
--cmap Blues --title "Cere_stops"

metagene chart Cerestops Cerestops_metagene_profile.txt --landmark "stop codon" --title "Cerestops"

###MakeWiggleWork

make_wiggle --count_files ../star_combo_no_rDNA/d1650_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P4offsets_edited.txt --min_length 26 --max_length 31 -o P4.wig
make_wiggle --count_files ../star_combo_no_rDNA/d1651_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset P6offsets_edited.txt --min_length 26 --max_length 31 -o P6.wig
make_wiggle --count_files ../star_combo_no_rDNA/d1652_comboShortIntron_no_rDNAAligned.sortedByCoord.out_no256.bam --fiveprime_variable --offset Cereoffsets_edited.txt --min_length 25 --max_length 30 -o Cere.wig
