function fish_prompt
	~/powerline-shell-clearly.py $status --shell bare ^/dev/null
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

function fish_right_prompt -d "Write out the date and time on right prompt"
	__print_date
	__print_time
	echo "[m"
end

### PATH ###
set default_path /usr/bin /usr/sbin /bin /sbin
set homebrew /usr/local/bin /usr/local/sbin
set android_sdk ~/Downloads/adt-bundle-mac-x86_64-20131030/sdk/platform-tools/
set android_sdk_toolchains ~/Downloads/adt-bundle-mac-x86_64-20131030/sdk/tools/
set -gx PATH $android_sdk $android_sdk_toolchains $homebrew $default_path

rvm current 1>/dev/null 2>/dev/null

