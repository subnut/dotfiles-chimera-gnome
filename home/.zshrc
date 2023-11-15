# vim: sw=0 ts=4 sts=4 et nowrap
export ZDOTDIR=${ZDOTDIR-$HOME/.zsh}
fpath=($ZDOTDIR/completions $fpath)


## `zsh-newuser-install`
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=30000
SAVEHIST=30000


## Config
setopt AUTO_CD                  # cd if command is dir name
setopt CORRECT                  # [nyae]? (Also see $SPROMPT)
setopt CDABLE_VARS              # `cd dir` - if dir doesn't exist, try ~dir
setopt HIST_VERIFY              # VERY IMPORTANT. `sudo !!` <enter> doesn't execute directly. instead, it just expands.
setopt HIST_IGNORE_DUPS         # ignore duplicate
setopt HIST_IGNORE_SPACE        # command prefixed by space are incognito
setopt HIST_REDUCE_BLANKS       # RemoveTrailingWhiteSpace
setopt INC_APPEND_HISTORY       # immediately _append_ to HISTFILE instead of _replacing_ it _after_ the shell exits
setopt INTERACTIVE_COMMENTS     # Allow comments using '#' in interactive mode
setopt PRINT_EXIT_VALUE
setopt PUSHD_IGNORE_DUPS
setopt NO_PUSHD_TO_HOME
setopt PUSHD_MINUS
setopt AUTO_PUSHD


## PATH
export PATH=./:$PATH
typeset -U PATH path    # remove duplicates


# Modules
zmodload zsh/terminfo
zmodload zsh/parameter


## Set terminal title
typeset -ga pre{cmd,exec}_functions
function title_precmd   { print -Pn "\e]0;%n@%m: %~\a"; }       # user@host: ~/cur/dir
function title_preexec  { printf "\e]0;%s\a" "${2//    / }"; }  # name of running command
precmd_functions+=title_precmd
preexec_functions+=title_preexec


## Terminal compatibility/tweaks
(( ${+commands[stty]} )) && {
    <>$TTY stty -echo                   # Don't echo keypresses while zsh is starting
    <>$TTY stty stop undef              # unbind ctrl-s from stty stop to allow fwd-i-search
    <>$TTY stty erase ${terminfo[kbs]}  # vim :term has ^H in $terminfo[kbs] but sets ^? in stty erase
} || true


## `compinstall`
zstyle ':completion:*' completer _complete _approximate _ignored
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit


## Other config
source $ZDOTDIR/env.sh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/aliases.sh
source $ZDOTDIR/hashdirs.zsh
source $ZDOTDIR/keybindings.zsh


## ZSH-specific features
for command in curl; do
    if (( ${+commands[$command]} )); then
        alias $command="noglob $command"
    fi
done
for func in gcm gcma; do
    if (( ${+functions[$func]} )); then
        alias $func="noglob $func"
    fi
done
