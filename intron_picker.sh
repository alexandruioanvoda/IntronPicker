#!/bin/bash
# USAGE: ./intron_picker.sh <exons_bed or exonic_circRNA_bed> <all_introns_bed>

sortBed -i $1 > temp1
cat temp1 > $1
sortBed -i $2 > temp2
cat temp2 > $2
rm temp1 temp2

bedtools closest -a $1 -b $2 -D a -s -io -id | awk '$13==-1' | sort -u -k4,4 | awk 'BEGIN{OFS="\t"}{print $1, $2, $3, $4, $6, $8, $9, $10, $13;}' > temp_upstream.csv
bedtools closest -a $1 -b $2 -D a -s -io -iu | awk '$13==1' | sort -u -k4,4 | awk 'BEGIN{OFS="\t"}{print $1, $2, $3, $4, $6, $8, $9, $10, $13;}' > temp_downstream.csv

cat temp_upstream.csv | awk '{print $4;}' > temp_id_upstream.csv
cat temp_downstream.csv | awk '{print $4;}' > temp_id_downstream.csv

grep -f temp_id_upstream.csv temp_id_downstream.csv > unified_ids.csv
rm temp_id_upstream.csv temp_id_downstream.csv

grep -f unified_ids.csv temp_upstream.csv | sort -k4,4 > introned_upstream.csv
grep -f unified_ids.csv temp_downstream.csv | sort -k4,4 > introned_downstream.csv
rm temp_upstream.csv temp_downstream.csv unified_ids.csv

paste introned_upstream.csv introned_downstream.csv | awk 'BEGIN{OFS="\t";}{print $1, $2, $3, $4, $5, $6, $7, $8, $15, $16, $17}' > output.csv
rm introned_upstream.csv introned_downstream.csv
echo -e 'Chromosome\tStart\tEnd\tID\tStrand\tIntron_upstream_start\tIntron_upstream_end\tIntron_up_id\tIntron_down_start\tIntron_down_end\tIntron_down_id' | cat - output.csv > temp && mv temp output.csv

#insert a line for dm3 bugs
#cat output.csv | grep -v -e "-1\t-1" > temp_output.csv && mv temp_output.csv output.csv
tail -n +2 output.csv | awk 'BEGIN{OFS="\t";}{print $1, $6, $7, $4, "0", $5}' > upstream_introns.bed
tail -n +2 output.csv | awk 'BEGIN{OFS="\t";}{print $1, $9, $10, $4, "0", $5}' > downstream_introns.bed
