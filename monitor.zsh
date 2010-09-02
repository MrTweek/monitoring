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
	cat mail.tmpl | sed "s/!!HOST!!/$host/g; s/!!DEAD!!/$dead/g; s/!!PORTS!!/$ports/g;" | mail -s 'Monitoring-Error' $mailto
}

