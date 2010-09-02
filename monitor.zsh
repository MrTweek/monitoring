#!/bin/zsh

host='yoshi.mega2000.de'
host='www.google.de'
ports=(22 25 53 80 443 993)
dead=()
timeout=1
mailto='philipp.gruber@flupps.net'

for port ($ports) {
	if (`nc -w $timeout -z $host $port`) {
		# ok
	} else {
		dead+=($port)
	}
}

# echo "[$dead]"
# echo ${#dead[@]}

if [[ 0 -ne ${#dead[@]} ]] {
	cat mail.tmpl | sed "s/!!HOST!!/$host/g; s/!!DEAD!!/$dead/g; s/!!PORTS!!/$ports/g;" | mail -s 'Monitoring-Error' $mailto
}

