alias shrug="printf %s '¯\_(ツ)_/¯'"
alias exists='command -v >/dev/null'
alias py=python3
alias vim=nvim


## Check --color support in `ls`
# NOTE: Should come *after* we've added ~/.local/bin to PATH
# if ls --color=auto && [ "$(ls --color=auto)" != "$(ls -- --color=auto)" ]
# 	then alias ls='ls --color=auto'
# fi 2>/dev/null 1>&2


alias ls='ls -F'
alias l='ls -lAF -h'
alias l.='ls -ldAF .*'
alias ls.='ls -dAF .*'


exists rg && {
    alias rgl='rg -l'
    alias rg='rg -. --no-heading --smart-case'
    alias rgs='rg -s'   # case-sensitive
    alias rgi='rg -i'   # case-insensitive
    alias rgh='rg --heading'
    alias rghs='rgh -s' # case-sensitive
    alias rghi='rgh -i' # case-insensitive
}


exists git && {
    alias g=git
    alias gsw='git switch'
    alias gst='git status'
    alias gsts='git status -bs'
    alias ga='git add'
    alias gai='git add -i'
    alias gaa='git add --all'
    alias gaav='git add --all --verbose'
    alias gc='git commit -v'
    alias gca='git commit -va'
    gcm()  { git commit -v  -m "$*"; }
    gcma() { git commit -va -m "$*"; }
    alias gp='git push'
    alias gpull='git pull'
    alias gfetch='git fetch'
    alias gpfwl='git push --force-with-lease'
    gpf() {
        >&2 echo DO NOT USE --force
        >&2 echo Use --force-with-lease instead
        return 1
    }
    alias gd='git diff --patience'
    alias gds='gd --staged'
    alias gdh='gd @'
    alias gdh1='gd @^ @'
    ginit() {
        git init
        git commit --allow-empty -m 'git init'
    }
    alias gl='git log --oneline --graph'
    alias glog='git log --stat'
    alias glogp='git log --stat --patch'
    gbl() { git blame -s "$@" | sed 's/ / │ /;s/)/│/' | less; }
    # alias gbl='git blame -s'

    ## man 7 gitrevisions
    # To list the last 5 commits -
    #       git log @~5..
    # To list the commits since we branched from 'main'
    #       git log main..
    # To list the commits in 'dev' since it branched from us
    #       git log ..dev
    # To list the commits in 'dev' and 'main' since they branched
    #       git log main...dev --left-right
}


exists ncdu && alias ncdu='ncdu --color off' || true
exists bat && alias batp='bat --style=header-filename' || true
