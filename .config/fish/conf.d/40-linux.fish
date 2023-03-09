if [ (uname) = 'Linux' ]
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
