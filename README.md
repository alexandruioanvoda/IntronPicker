# IntronPicker
This script picks introns flanking the circRNAs for potential binding and conservation analysis purposes.
CircRNAs are a novel form of non-coding RNAs with growing attention from the scientific community.

## Prerequisites
Bash
bedtools
grep
paste

## How to install
Copy and paste the following commands in your terminal:
```
git clone https://github.com/alexandruioanvoda/IntronPicker
cd ./IntronPicker
chmod +x intron_picker.sh
```
## How to use

1. Download a BED6 file containing all the intronic annotations from UCSC Tables (https://genome.ucsc.edu/cgi-bin/hgTables)

2. Copy the BED containing all your circRNA annotations (or any annotations of which you want the find the flanking introns of) in the IntronPicker folder

3. Run IntronPicker by typing this in terminal (after navigating into the folder):
```
./intron_picker.sh circRNAs.bed intron_intervals.bed
```
4. Output is in the same folder
