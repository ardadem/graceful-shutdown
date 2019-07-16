#!/bin/bash
TIMEOUT=10
APPLIST_TO_TERMINATE=(
	# edit this list
	qbittorrent
	steam
	discord
)

close_windows () {
	wmctrl -l | awk '{print $1}' | while read -r wId
	do
		wmctrl -i -c $wId
	done
}

window_timeout_countdown () {
	for i in $(seq 1 $TIMEOUT);
	do
		if [[ -z $(wmctrl -l) ]]; then
			return 0
		fi
		sleep 1
	done
	exit 1
}

terminate_processes () {
	pidof $APPLIST_TO_TERMINATE | while read -r pId
	do
		kill -s TERM $pId
		tail --pid=$pId -f /dev/null
	done
}

close_windows
window_timeout_countdown
terminate_processes
systemctl poweroff
