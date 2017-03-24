#!/bin/bash
# USAGE: ./pick_introns.sh <exons_bed or exonic_circRNA_bed> <all_introns_bed>

bedtools closest -a $1 -b $2 -D a -s -io -iu | awk '$13==1' | sort -u -k4,4 | awk 'BEGIN{OFS="\t"}{print $1, $2, $3, $4, $6, $8, $9, $10, $13;}' > temp_downstream.csv
bedtools closest -a $1 -b $2 -D a -s -io -id | awk '$13==-1' | sort -u -k4,4 | awk 'BEGIN{OFS="\t"}{print $1, $2, $3, $4, $6, $8, $9, $10, $13;}' > temp_upstream.csv

cat temp_downstream.csv | awk '{print $4;}' > temp_id_downstream.csv
cat temp_upstream.csv | awk '{print $4;}' > temp_id_upstream.csv

grep -f temp_id_upstream.csv temp_id_downstream.csv > unified_ids.csv
rm temp_id_upstream.csv temp_id_downstream.csv

grep -f unified_ids.csv temp_upstream.csv | sort -k4,4 > introned_upstream.csv
grep -f unified_ids.csv temp_downstream.csv | sort -k4,4 > introned_downstream.csv
rm temp_upstream.csv temp_downstream.csv

paste introned_upstream.csv introned_downstream.csv | awk 'BEGIN{OFS="\t";}{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $15, $16, $17, $18;}' > output.csv
