function tmlist() {
  tmutil listbackups -t
}

function tmcalc() {
  tmutil calculatedrift $(tmutil machinedirectory)
}

function tmthin() {
  tmutil thinlocalsnapshots / 21474836480 4
}

function tmshift() {
  # tmutil destinationinfo
  tmutil listbackups -t | head -$1
  tmutil listbackups -t | head -$1 | while read -r time; do sudo tmutil delete -d $(tmutil machinedirectory) -t $time; done
}

function tmkeep() {
  tmutil listbackups -t | awk -v n=$1 'NR>n{print line[NR%n]};{line[NR%n]=$0}'
  tmutil listbackups -t | awk -v n=$1 'NR>n{print line[NR%n]};{line[NR%n]=$0}' | while read -r time; do sudo tmutil delete -d $(tmutil machinedirectory) -t $time; done
}
