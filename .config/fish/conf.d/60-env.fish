### blahblahblah env
alias gti git
alias l ls

bind \eOF beginning-of-line
bind \eOH end-of-line

test -e {$HOME}/.nix-profile/etc/profile.d/nix.fish
	and source {$HOME}/.nix-profile/etc/profile.d/nix.fish

test -e {$HOME}/.bin
	and set -gx PATH {$HOME}/.bin $PATH

if status --is-interactive
	source (command -q rbenv  && rbenv  init - | psub)
	source (command -q nodenv && nodenv init - | psub)
	source (command -q goenv  && goenv  init - | psub)
	source (command -q anyenv && anyenv init - | psub)
	source (command -q direnv && direnv hook fish | psub)
end


