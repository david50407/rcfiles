
### CONFIG ###
set -g __powerline_color_root af0000
set -g __powerline_color_path 0087af
set -g __powerline_color_cwd 0087ff
set -g __powerline_color_cmd_passed ffffff
set -g __powerline_color_cmd_failed ff5f87
set -g __powerline_color_repo_clean afd700
set -g __powerline_color_repo_dirty d7005f
set -g __powerline_color_rvm d70000
set -g __powerline_color_crenv 00afff
set -g __powerline_color_nvm afd700

function powerline -d "Powerline everywhere!"
	set -l last_status $status

	__powerline_segment_cwd
	__powerline_segment_git
	__powerline_segment_rvm
	__powerline_segment_crenv
	__powerline_segment_nvm
	__powerline_segment_indicator $last_status
	set_color normal
end

function __powerline_segment_cwd -d "Powerline current work directory"
	set -l names (__powerline_segment_cwd_relative_path (pwd))
	
	if test (count $names) -gt 1
		set_color $__powerline_color_path

		for n in $names[1..-2]
			switch $n
			case '/'
				set_color $__powerline_color_root
				echo -n '/'
				set_color $__powerline_color_path
			case '~'
				echo -n ' '
			case '*'
				echo -n $n'/'
			end
		end
	end

	set_color $__powerline_color_cwd
	switch $names[-1]
	case '/'
		set_color $__powerline_color_root
		echo -n '/'
		set_color $__powerline_color_cwd
	case '~'
		echo -n '~'
	case '*'
		echo -n $names[-1]
	end

	echo -n ' > '
end

function __powerline_segment_cwd_relative_path -d "Calcute path relative to HOME"
	set -l fullpath (string trim -r -c '/' $argv[1])
	set -l home (string trim -r -c '/' $HOME)'/'
	test (string sub -l 1 -s 1 $fullpath) != '/'
		and set fullpath (pwd)"/$fullpath"
	set fullpath "$fullpath/"

	set -l path (string replace $home '~/' $fullpath)
	set -l paths (string split '/' (string trim -c '/' $path))
	test $paths[1] != '~'
		and echo '/'
	for p in $paths
		test -n $p
			and echo $p
	end
end

function __powerline_segment_git -d "Powerline Git"
	not command -sq git
		and return 1

	set -l branch (command git symbolic-ref -q HEAD 2>/dev/null)
	set -l os $status
	switch $os
		case 0
			set branch (string replace 'refs/heads/' '' $branch)
		case 1
			set branch "(Detached)"
		case '*'
			return
	end

	set -l git_status (__powerline_segment_git_status)
	set -l dirty $git_status[1]
	set -l untracked $git_status[2]
	set -l position $git_status[3]
	
	test $dirty = yes
		and set_color $__powerline_color_repo_dirty
		or set_color $__powerline_color_repo_clean
	printf "%s%s%s > " $branch $position (test $untracked = yes; and echo ' +')
end

function __powerline_segment_git_status -d "Fetch git status"
	set -l dirty yes
	set -l untracked no
	set -l position

	set -l git_status (command git status --ignore-submodules 2>/dev/null)
	string match -qr 'nothing to commit' -- $git_status
		and set dirty no
	string match -qr 'Untracked files' -- $git_status
		and set untracked yes
	set -l offset (string match -r 'Your branch is (ahead|behind).*?(\d+) comm' -- $git_status)
	if test -n "$offset"
		set position " $offset[3]"(test $offset[2] = 'ahead'; and echo '^'; or echo 'v')
	end

	echo $dirty
	echo $untracked
	echo $position
end

function __powerline_segment_rvm -d "Powerline RVM"
	not command -sq ruby
		and return 1

	set -l ruby_version (string split ' ' (command ruby -v))[2]
	set -l gemset
	test -n $GEM_HOME
		and set gemset (string split '@' "$GEM_HOME@")[2]

	set_color $__powerline_color_rvm
	printf '%s%s > ' $ruby_version (test -n $gemset; and echo "@$gemset")
end

function __powerline_segment_crenv -d "Powerline crenv"
	not command -sq crystal
		and return 1

	set -l crystal_version (string split ' ' (command crystal -v))[2]

	set_color $__powerline_color_crenv
	printf '%s > ' $crystal_version
end

function __powerline_segment_nvm -d "Powerline nvm"
	not command -sq node
		and return 1

	set -l node_version (string split 'v' (command node -v))[2]

	set_color $__powerline_color_nvm
	printf '%s > ' $node_version
end

function __powerline_segment_indicator -d "Powerline indicator"
	set -l last_status $argv[1]

	set_color normal
	echo -n "\$ "
	test $last_status -ne 0
		and set_color $__powerline_color_cmd_failed
		or set_color $__powerline_color_cmd_passed
	echo -n "> "
end
