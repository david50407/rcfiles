if [ (uname) = 'Darwin' ]
	set is_rosetta (sysctl -n sysctl.proc_translated)
	if [ $is_rosetta = '1' ]
		alias arm64 "arch -arch arm64"
		set homebrew /opt/homebrew.x86_64/sbin /opt/homebrew.x86_64/bin
	else
		alias x86 "arch -arch x86_64"
		set homebrew /opt/homebrew/sbin /opt/homebrew/bin
	end
	test -e /opt/homebrew/bin/qrencode
		and function qrc
			cat | qrencode -t png -s 15 -o - | open -fa Preview.app
		end

	test -e {$HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
		and set -x SSH_AUTH_SOCK {$HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

	set -q PERL5LIB; and set -x PERL5LIB ~/perl5/lib/perl5:$PERL5LIB;
	set -q PERL5LIB; or set -x PERL5LIB ~/perl5/lib/perl5;
	set -q PERL_LOCAL_LIB_ROOT; and set -x PERL_LOCAL_LIB_ROOT ~/perl5:$PERL_LOCAL_LIB_ROOT;
	set -q PERL_LOCAL_LIB_ROOT; or set -x PERL_LOCAL_LIB_ROOT ~/perl5;
	set -x PERL_MB_OPT --install_base\ \"~/perl5\";
	set -x PERL_MM_OPT INSTALL_BASE=~/perl5;

	set -gx ANDROID_HOME ~/Library/Android/sdk
	set -gx ANDROID_SDK_ROOT ~/Library/Android/sdk
	set default_path /usr/local/bin /usr/bin /usr/sbin /bin /sbin
	set android_sdk $ANDROID_HOME/platform-tools/
	set android_sdk_toolchains $ANDROID_HOME/tools/
	set llvm_path /usr/local/opt/llvm/bin/
	set perl_path ~/perl5/bin
	set -gx PATH $perl_path $llvm_path $android_sdk $android_sdk_toolchains $homebrew $default_path
	set -gx LIBRARY_PATH $LIBRARY_PATH /usr/local/lib
	set -gx BYOBU_PREFIX /usr/local
end

