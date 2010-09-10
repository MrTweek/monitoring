#!/bin/zsh

source 'monitor.cfg'

dead=()

for port ($ports) {
	if (`nc -w $timeout -z $host $port`) {
		# ok
	} else {
		dead+=($port)
	}
}

if [[ 0 -ne ${#dead[@]} ]] {
	message=`cat mail.tmpl | sed "s/!!HOST!!/$host/g; s/!!DEAD!!/$dead/g; s/!!PORTS!!/$ports/g;"`
	echo $message | mail -s "[Monitor] Problems on $host" $mailto
	if [[ 1 -eq $sendsms ]] {
		./sipgateAPI-sms.pl "$username" "$password" "$number" "'$message'"
	}
}


