#!/bin/bash
#set -x
NAGIOS=('0' '1' '2' '3')
count=()
cnt=0
ID="$(grep '\->' /var/log/exim/main.log | awk '{print $3}' | sort -n | uniq -c | sort -nr | head -10 | awk '{if ($1 >= 30) print $1 "," $2}' )"

echo $ID

if [ -z "$ID" ]
then
	echo "Everything is Okay"
	exit ${NAGIOS[0]}
else
	for i in $ID
	do
		counter="$(awk -F ',' '{print $1}' <<< $i)"
		id="$(awk -F ',' '{print $2}' <<< $i)" 
		count=(${count[@]} $counter "$(grep '<=' /var/log/exim/main.log | grep "$id" | awk '{print $5}' | grep "@")" )
		let "cnt++"
	done
	echo "Possible Spamers: ${count[@]}"
	exit ${NAGIOS[2]}
fi



