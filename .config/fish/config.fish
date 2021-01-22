set os (uname)

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
	switch $os
	case Darwin
		hostname | sed -E 's/Davy-|davy-//' | sed -E 's/\..+//'
	case Linux
		hostname | sed 's/Davy-//i'
  end
	echo " "
end

function fish_right_prompt -d "Write out the date and time on right prompt"
	__print_date
	__print_time
	__print_host
	echo "[m"
end

### PATH ###
if [ $os = 'Darwin' ]
	set arch (uname -m)
	if [ $arch = 'arm64' ]
		set is_rosetta (sysctl -n sysctl.proc_translated)
		if [ $is_rosetta = '1' ]
			set homebrew /opt/homebrew.x86_64/bin
		else
			alias x86 "arch -arch x86_64"
			set homebrew /opt/homebrew/bin
		end
	else
		set homebrew /opt/homebrew/bin
	end

	set -gx ANDROID_HOME ~/Library/Developer/AndroidSDK
	set default_path /usr/local/bin /usr/bin /usr/sbin /bin /sbin
	set android_sdk $ANDROID_HOME/platform-tools/
	set android_sdk_toolchains $ANDROID_HOME/tools/
	set llvm_path /usr/local/opt/llvm/bin/
	set -gx PATH $llvm_path $android_sdk $android_sdk_toolchains $homebrew $default_path
	set -gx LIBRARY_PATH $LIBRARY_PATH /usr/local/lib
	set -gx BYOBU_PREFIX /usr/local
end

if [ $os = 'Linux' ]
	set -gx ANDROID_HOME /usr/local/android-sdk-linux
	set -x PERL_MB_OPT --install_base\ \"/home/davy/perl5\";
	set -x PERL_MM_OPT INSTALL_BASE=/home/davy/perl5;
	set -x PERL5LIB /home/davy/perl5/lib/perl5;
	set heroku /usr/local/heroku/bin
	set android_sdk $ANDROID_HOME/platform-tools/
	set android_ndk /usr/local/android-ndk-linux
	set android_sdk_toolchains $ANDROID_HOME/tools/
	set npm_path /home/davy/.npm-global/bin
	set crenv_path /home/davy/.crenv
	set diff_so_fancy_path /home/davy/.config/opt/diff-so-fancy
	set own_bin_path /home/davy/.bin
	set -gx PATH $own_bin_path $diff_so_fancy_path $crenv_path/bin $npm_path $android_sdk $android_sdk_toolchains $android_ndk $heroku $PATH
	
	. {$HOME}/.config/fish/functions/ssh-agent.fish

	set -gx PATH "$crenv_path/shims" $PATH
	set -gx CRENV_SHELL fish
	. {$crenv_path}/completions/crenv.fish
	command crenv rehash 2>/dev/null
	function crenv
		set command $argv[1]
		set -e argv[1]

		switch "$command"
		case rehash shell update
		. (crenv "sh-$command" $argv|psub)
		case '*'
		command crenv "$command" $argv
		end
	end
end

alias gti git

bind \eOF beginning-of-line
bind \eOH end-of-line

test -e {$HOME}/.config/fish/functions/rvm.fish
	and source {$HOME}/.config/fish/functions/rvm.fish
	and rvm reload >/dev/null 2>/dev/null

test -e {$HOME}/.nix-profile/etc/profile.d/nix.fish
	and source {$HOME}/.nix-profile/etc/profile.d/nix.fish
