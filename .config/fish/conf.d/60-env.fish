### blahblahblah env
test -e {$HOME}/.rbenv/bin/rbenv
	and set -Ux fish_user_paths "$HOME/.rbenv/bin"

alias gti git
alias l ls

bind \eOF beginning-of-line
bind \eOH end-of-line

test -e {$HOME}/.nix-profile/etc/profile.d/nix.fish
	and source {$HOME}/.nix-profile/etc/profile.d/nix.fish

test -e {$HOME}/.bin
	and set -gx PATH {$HOME}/.bin $PATH

if status --is-interactive
	source (rbenv init -|psub)
	source (nodenv init -|psub)
	source (goenv init -|psub)
	source (anyenv init -|psub)
end

direnv hook fish | source

