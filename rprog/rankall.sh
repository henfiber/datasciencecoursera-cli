#!/bin/bash
# Simulating Coursera "R Programming" - Programming Assignment 3
# with Linux Command line tools

# Globals
INPUT_FILE=outcome-of-care-measures.csv  # this could be given as an argument as well
order='-k1.1d -k2.1g -k3.1d'  # default arguments to sort command - to be changed when num="worst"

# CLI Arguments
outcome=${1:-11}	# Default value : 11 (Heart attack)
num=${2:-1}			# Default value : Get the first (best) hospital


# Rankall function  (R: rankall(outcome, num = "best") )
# Return the n-ranked hospital in each state, for a specific outcome
rankall() {
	awk -F'","' -v outcome=$outcome 'NR!=1 && $outcome ~ /[0-9.]/ {print $7";"$outcome";"$2}' $INPUT_FILE |
	sort -t';' $order |
	awk -v n=$num -F';' '++a[$1] == n { print $1"\t"$3 } END { for (st in a) if (a[st] < n) print st"\t""NA"; }' |
	sort
}



# MAIN

	# Parsing num and outcome
	case "$num" in
		best)  num=1 ;;
		worst) num=1; order='-k2.1rg -k1.1d -k3.1d' ;;  # sort by rate descending
	esac

	case "$outcome" in
		"heart attack") 	outcome=11 ;;
		"heart failure")	outcome=17 ;;
		"pneumonia")  		outcome=23 ;;
		11|17|23)			: ;;
		*)					echo "invalid outcome" >&2; exit 2 ;;
	esac



	# Having set the parameters, Run the rankall function
	rankall
