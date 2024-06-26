## Add ~/.local/bin to PATH
# NOTE: We use :$PATH: to handle if the required path is at start or end of $PATH
# See: https://unix.stackexchange.com/a/32054
echo ":$PATH:" | grep -Fq ":$HOME/.local/bin:" ||
    export PATH=$HOME/.local/bin:$PATH


export EDITOR=vim
export DIFFPROG='nvim -d'
export LESS='-i -R -#.3'

[ "$TERM" = wezterm ] &&
    export EDITOR=nvim

export GOPATH=$HOME/.cache/gocache
export BAT_THEME=ansi
export MOZ_WEBRENDER=1
export MOZ_ACCELERATED=1
export FZF_DEFAULT_OPTS=`
tr '\n' ' ' <<-EOF
	--ansi
	--margin 1,2
	--color light
	--bind ctrl-v:toggle-preview
	--preview-window right:60%:hidden:wrap
EOF`


## Add ~/.local/share/man to MANPATH
# - Check if the directory even exists
# - Check if MANPATH already contains it
# - Set MANPATH accordingly
[ ! -d "$HOME/.local/share/man" ] || {
    [ ! -z "$MANPATH" ] && {
        echo ":$MANPATH:" | grep -Fq ":$HOME/.local/share/man:" ||
        export MANPATH="$HOME/.local/share/man:$MANPATH"
        true  # just in case
    };} ||
export MANPATH="$HOME/.local/share/man"`
    grep ^manpath /etc/man.conf |
    while read -r _ path; do
        printf :%s "$path"
    done`


# vim: et sw=4 sts=4 ts=4 ft=sh nowrap
