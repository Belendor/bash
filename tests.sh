#!/bin/bash

input_filename=input
output_filename=output


function ping {
	echo $1
  ping -c 2 $1 | grep -Eo '[0-9]{1,3}% packet loss' >>ping.txt
}

if [ -f $input_filename ]
then
	echo -e "This is the content of input.csv file\n"
	cat $input_filename

	if [ -f $output_filename ]
	then
		echo "File exists, deleting..."
		rm $output_filename
		ls -a
	else
		echo -e "No $output_filename file yet in the folder\n"
		ls -a
	fi

	echo "Parsing a file..."
	exec < $input_filename
	read header
	header="$header,IP reachable,Hostname Registered,SSH Enabled"
	echo $header >> $output_filename
	while read line
	do
		ip=$(cut -d ',' -f 1 <<< "$line")
		dns=$(cut -d ',' -f 2 <<< "$line")

		# check if PINGable

		ping $ip &

		# ping $value1 -c2 1>>ping.txt 2>/dev/null &
		# success=$?
		# if [ $success -eq 0 ]
		# then
		# 	result="$line,YES"
		# else
		# 	result="$line,NO"
		# fi

		# check if dig returns an IP for hostname
		# dig $value2  >>dig.txt &

		# nohup bash -c "dig $value2 +short
		# echo $? 
		# if [ $? -ne 0 ]
		# then
		# 	echo '$value2,Yes' >> dig.txt
		# else
		# 	echo '$value2,No' >> dig.txt
		# fi" 1>/dev/null 2>/dev/null &

		# if [ -z $success2 ]
		# 	then
		# 			result="$result,NO"
		# 	else
		# 			result="$result,YES"
		# 	fi

		#check if ssh port 22 is open and accepts connections

		# nmap $value1 -Pn -p 22 | egrep -io 'open|closed|filtered' >>nmap.txt &

		# if [ $sshstatus == "open" ];then
		# 	echo "$result,YES" >> $output_filename
		# else 
		# 	echo "$result,NO" >> $output_filename
		# fi
	done
	echo "New file created with new contents"
	ls -a
	cat $output_filename
else
	echo "File $input_filename does not exist."
	exit
fi

