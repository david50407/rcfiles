if ! string match -qr 'fish$' "$SHELL"
	set -gx SHELL (which fish)
	[ -z "$SHELL" ] && set -gx SHELL fish
end

function fish_prompt
	powerline
end

function __print_date
	echo "[38;5;208m" # fg color
	echo "<"
	date "+ %m/%d "
end

function __print_time
	echo "[38;5;148m" # fg color
	echo "<"
	date "+ %H:%M "
end

function __print_host
	echo "[38;5;31m" # fg color
	echo "< "
	switch (uname)
	case Darwin
		hostname | sed -E 's/Davy-|davy-//' | sed -E 's/\..+//'
	case Linux
		hostname | sed 's/Davy-//i'
  end
	[ (sysctl -n sysctl.proc_translated) = '1' ] && echo ' (x86)'
	echo " "
end

function fish_right_prompt -d "Write out the date and time on right prompt"
	__print_date
	__print_time
	__print_host
	echo "[m"
end
