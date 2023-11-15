## Add ~/.local/bin to PATH
# NOTE: We use :$PATH: to handle if the required path is at start or end of $PATH
# See: https://unix.stackexchange.com/a/32054
echo ":$PATH:" | grep -Fq ":$HOME/.local/bin:" ||
    export PATH=$HOME/.local/bin:$PATH


export EDITOR=nvim
export DIFFPROG='nvim -d'
export LESS='-i -R -#.3'


export GOPATH=$HOME/.cache/gocache
export BAT_THEME=ansi
export MOZ_WEBRENDER=1
export MOZ_ACCELERATED=1
export FZF_DEFAULT_OPTS="\
	--ansi \
	--margin 1,2 \
	--color=light \
	--bind ctrl-v:toggle-preview \
	--preview-window 'right:60%:hidden:wrap' \
"

# vim: et sw=4 sts=4 ts=4 ft=sh nowrap
