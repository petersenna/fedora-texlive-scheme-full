#!/bin/bash
#
# This script looks for changes on .tex files and call make pdf on every change
#
# I keep a terminal running this script while I edit the tex file, so I get a
# new pdf on every file save.
#
# Needed packages: inotify-tools
#
# Based on:
# http://razius.com/articles/auto-refreshing-google-chrome-on-file-changes/

IFILE='./*.tex ./*.cls'
TIME_FORMAT='%F %H:%M'
OUTPUT_FORMAT='%T Refreshing due changes on %w.'

clear

while inotifywait -q -r --timefmt "${TIME_FORMAT}" --format "${OUTPUT_FORMAT}" $IFILE; do
	while [ -f Make-running ];do
		echo -e "\e[32m make running, skipping\e[0m"
		sleep 2
	done

	make pdf &> /dev/null
	if [[ $? -eq 0 ]];then
		echo -e "\e[32mmake pdf OK!\e[0m"
	else
		echo -e "\e[31mmake pdf FAILED!\e[0m"
		make unlock &> /dev/null
	fi

	# Just to avoid dangerous loops
	sleep 1
done
