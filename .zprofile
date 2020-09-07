#!/bin/sh

# Profile file. Runs on login. Environmental variables are set here.

# Adds `~/.local/bin` to $PATH
#export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"

# Tiny tweak I made to a linux terminal command code (no idea what it's
# actually called, it's something to do with terminfo) stored here. The tweak
# is changing cnorm from \E[?25h\E[?0c to \E[?25h\E[?16;192c
# This makes it so I keep my red block cursor after exiting lf.
export TERMINFO="$HOME/.config/terminfo"

# Default programs:
export EDITOR="nvim"
export FILE="lf"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/cache"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
#export INPUTRC="$HOME/.config/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# GPG
export GNUPGHOME="$HOME/.local/.SEC/gnupg"
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1

# Other program settings:
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"

# Set linux virtual console colors from Xresources
if [ "$TERM" = "linux" ]
then
	# Use bright red software cursor (non-blinking block):
	printf "\e[?16;192c"
	# Set foreground color to bright green:
	#setterm --bold on --foreground green --store
	setterm --foreground green --store
	if [ -f ~/.config/Xresources ]
	then
		_SEDCMD='s/^*.color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
		_AWKCMD='$1 < 16 {printf "\\e]P%X%s", $1, $2}'
		for i in $(sed -n "$_SEDCMD" ~/.config/Xresources | awk "$_AWKCMD")
		do
			printf "$i"
		done
	fi
fi

[ -d "$HOME/.local/share/mpd" ] || mkdir -p "$HOME/.local/share/mpd"
# mpd >/dev/null 2>&1 &
mpd >/dev/null 2>&1

[ ! -f ~/.config/shortcutrc ] && shortcuts >/dev/null 2>&1

# If running bash, load bashrc.
echo "$0" | grep "bash$" >/dev/null && [ -f ~/.config/bashrc ] && source "$HOME/.config/bashrc"

# Switch escape and caps if tty:
# (temp disabled; really messes with me when remoting in to the host via RDP
# to work on the VM)
#sudo -n loadkeys ~/.config/ttymaps.kmap 2>/dev/null
sudo -n loadkeys ${XDG_DATA_HOME:-$HOME/.local/share}/larbs/ttymaps.kmap 2>/dev/null

# Start graphical server if X not already running.
#[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

# Start Tmux
#[[ $- == *i* ]] && [[ -z ${$TMUX+x} ]] && tmux
