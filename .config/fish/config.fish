set $os (uname)

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
if [ $os = 'Darwin' ]
	set -gx ANDROID_HOME ~/Library/Developer/AndroidSDK
	set default_path /usr/bin /usr/sbin /bin /sbin
	set homebrew /usr/local/bin /usr/local/sbin
	set npm_path /usr/local/share/npm/bin
	set android_sdk $ANDROID_HOME/platform-tools/
	set android_sdk_toolchains $ANDROID_HOME/tools/
	set -gx PATH $android_sdk $android_sdk_toolchains $npm_path $homebrew $default_path
	set -gx LIBRARY_PATH $LIBRARY_PATH /usr/local/lib
end

rvm current 1>/dev/null 2>/dev/null
bass source ~/.nvm/nvm.sh 1>/dev/null 2>/dev/null

