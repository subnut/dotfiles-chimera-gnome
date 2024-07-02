## We need to run commands inside our prompts
setopt PROMPT_SUBST


## Array of colors to use in prompts
typeset -gA _tp_color
if [[ ${terminfo[colors]} -gt 8 ]]
then # At least 16-bit
    _tp_color[red]=9
    _tp_color[grey]=8
    _tp_color[green]=10
else # Limited to 8-bit
    _tp_color[red]=1
    _tp_color[grey]=7
    _tp_color[green]=2
fi

# Grey is sometimes nigh invisible in some colorschemes
# So, if 256-colors is available, use 244 instead
if [[ ${terminfo[colors]} -eq 256 ]]; then
    _tp_color[grey]=244
fi


## Helper functions
# _tp_exec   - to run commands inside $PROMPT without changing $?
# _tp_expand - to print something with prompt expansion
function _tp_exec { local exitcode=$?; "$@"; return $exitcode }
function _tp_expand { print -n -- "${(%)*}" }


## The prompt that's shown for commands have have been executed
## ie. the prompt that's gonna show up in your scrollback buffer
## ie. the "permanent" prompt
_TP_PERM_PROMPT=
_TP_PERM_PROMPT+='%B'
_TP_PERM_PROMPT+='[%~]%(!. #.) '
_TP_PERM_PROMPT+='%b'
_TP_PERM_PROMPT+='$(_tp_exec __tphfn__venv grey R)'

## The "transient" prompt
## ie. the prompt that's shown until the command is executed
_TP_TRAN_PROMPT=
_TP_TRAN_PROMPT+='$(_tp_exec __tphfn__ssh grey R)'
_TP_TRAN_PROMPT+='%B'
_TP_TRAN_PROMPT+='%~'
_TP_TRAN_PROMPT+='%b'
_TP_TRAN_PROMPT+='$(_tp_exec __tphfn__venv grey L)'
_TP_TRAN_PROMPT+='$(_tp_exec echoti hpa $((COLUMNS)))'
_TP_TRAN_PROMPT+='%(?..$(_tp_exec echoti cub ${#?})%B%F{'${_tp_color[red]}'}%?%f%b)'

## The "main" prompt
## ie. the stuff that's gonna show on the same line as the command that'll be executed
_TP_MAIN_PROMPT=
_TP_MAIN_PROMPT+='%B'
_TP_MAIN_PROMPT+='%(?.%F{'${_tp_color[green]}'}.%F{'${_tp_color[red]}'})'
_TP_MAIN_PROMPT+='%(!.#.$)'
_TP_MAIN_PROMPT+='%f'
_TP_MAIN_PROMPT+='%b'
_TP_MAIN_PROMPT+=' '

# _TP_MAIN_PROMPT='%F{'$${_tp_color[grey]}'}$%f'
# _TP_MAIN_PROMPT='%B%(?.%F{green}.%F{red})%(!.#.$)%f%b'


## Show execution time in RPROMPT
zmodload zsh/datetime
typeset -ga _epochtime_precmd
typeset -ga _epochtime_preexec
function _exectime {
    # Define this function AFTER the very first prompt has been shown
    # Otherwise, it shows a bogus value in the RPROMPT, since
    # _epochtime_preexec is not defined yet
    function _exectime {
        RPROMPT="%f"
        local sec=$(( _epochtime_precmd[3] - _epochtime_preexec[3] ))
        [[ $sec -lt 0.01 ]] && return
        if [[ $sec -lt 1 ]]
        then RPROMPT="${sec:0:4}s$RPROMPT"   # 0.xxx -- 4 chars
        else
            sec=$(( _epochtime_precmd[1] - _epochtime_preexec[1] ))
            RPROMPT="$(( sec % 60 ))s$RPROMPT"
            [[ $(( sec /= 60 )) -gt 0 ]] && RPROMPT="$(( sec % 60 ))m $RPROMPT"     # mins
            [[ $(( sec /= 60 )) -gt 0 ]] && RPROMPT="$(( sec % 24 ))h $RPROMPT"     # hours
            [[ $(( sec /= 60 )) -gt 0 ]] && RPROMPT="$(( sec % 24 ))d $RPROMPT"     # days
        fi
        RPROMPT="%F{${_tp_color[grey]}}$RPROMPT"
    }
}
function _exectime_preexec { _epochtime_preexec=($epochtime $EPOCHREALTIME)  }
function _exectime_precmd  { _epochtime_precmd=($epochtime $EPOCHREALTIME)   }
preexec_functions+=_exectime_preexec
precmd_functions+=_exectime_precmd
precmd_functions+=_exectime


## Show warning if buffer empty
EMPTY_BUFFER_WARNING_TEXT='Buffer empty!'
EMPTY_BUFFER_WARNING_COLOR=${_tp_color[red]}
zle -N accept-line
function accept-line {
    if [[ $#BUFFER -ne 0 ]]
    then zle .accept-line
    else
        echoti cud1
        # The next two lines MUST NOT BE INTERCHANGED
        _tp_expand "${_TP_MAIN_PROMPT}"
        echoti cuu1
        echoti sc
        echoti cud 1
        echoti hpa 0
        _tp_expand "%F{$EMPTY_BUFFER_WARNING_COLOR}"$EMPTY_BUFFER_WARNING_TEXT'%f'
        echoti ed
        echoti rc
        # For the meaning of cud1,ed,hpa,... see terminfo(5)

        # Create function that resets warning
        function _empty_buffer_warning_reset {
            unfunction _empty_buffer_warning_reset
            echoti sc
            echoti cud 1
            echoti hpa 0
            printf "%${#EMPTY_BUFFER_WARNING_TEXT}s"
            echoti ed
            echoti rc
        }

        # Reset the warning if any character is typed
        zle -N self-insert
        function self-insert {
            unfunction self-insert
            zle .self-insert
            zle -A .self-insert self-insert
            _empty_buffer_warning_reset
        }
    fi
}


## Transient prompt
[[ -c /dev/null ]]  || return 0
zmodload zsh/system || return 0

typeset -g __tp_newline=
function __tp_setprompt {
    PROMPT='$__tp_newline'
    PROMPT+=${_TP_TRAN_PROMPT}
    PROMPT+=$'\n'${_TP_MAIN_PROMPT} 
}; __tp_setprompt

zle -N send-break       __tp_wid_send-break
zle -N clear-screen     __tp_wid_clear-screen
zle -N zle-line-finish  __tp_wid_zle-line-finish

function __tp_wid_send-break { __tp_wid_zle-line-finish; zle .send-break; }
function __tp_wid_clear-screen { __tp_newline=; zle .clear-screen; }
function __tp_wid_zle-line-finish {
    (( ! __tp_promptfd )) && {
        sysopen -r -o cloexec -u __tp_promptfd /dev/null
        zle -F $__tp_promptfd __tp_restore_prompt
    }; zle && PROMPT=$_TP_PERM_PROMPT RPROMPT= zle reset-prompt && zle -R
}

function __tp_restore_prompt {
    exec {1}>&-
    (( ${+1} )) && zle -F $1
    __tp_promptfd=0
    __tp_setprompt
    zle reset-prompt
    zle -R
}

(( ${+precmd_functions} )) || typeset -ga precmd_functions
(( ${#precmd_functions} )) || {
    precmd_functions=(do_nothing)
    do_nothing() {true}
}

precmd_functions+=__tp_precmd
function __tp_precmd {
    # We define __tp_precmd in this way because we don't want
    # __tp_newline to be defined on the very first precmd.
    TRAPINT() {zle && __tp_wid_zle-line-finish; return $(( 128 + $1 ))}
    function __tp_precmd {
        TRAPINT() {zle && __tp_wid_zle-line-finish; return $(( 128 + $1 ))}
        __tp_newline=$'\n'
    }
}

### helper functions for extensibility purposes ###
function __tphfp {
    # Takes three arguments -
    #   1. The text to print
    #   2. The color to print it in
    #   3. [OPTIONAL] Formatting options
    #
    # The optional argument -
    #   If the argument contains 0, then output isn't colorized
    #   The output is left-padded by the number of L/l in the argument
    #   The output is right-padded by the number of R/r in the argument
    local out="$1" col="$2" opt="$3"
    test ! 0 = "${opt//[^0-9]/}" && out="%F{${_tp_color[$col]}}${out}%f"
    printf %${#opt//[^lL]/}s; printf %s "$out"; printf %${#opt//[^rR]/}s;
}

### python venv ###
function __tphfn__venv {
    (( ${+VIRTUAL_ENV} )) || return 0
    __tphfp "($(basename $VIRTUAL_ENV))" "$@"
};

### ssh ###
function __tphfn__ssh {
    (( ${+SSH_CONNECTION} )) || return 0
    __tphfp "%n@%m" "$@"
};


## Show vi mode
#function _vi_mode_show_mode {
#    echoti sc
#    echoti cud 1
#    echoti hpa 0
#    echoti el
#    (( ${#1} )) && _tp_expand '%B'$1'%b'
#    echoti rc
#}
#
#function _vi_mode-visual-mode { _vi_mode_show_mode VISUAL; zle .visual-mode }
#zle -N {,_vi_mode-}visual-mode
#function _vi_mode-vi-replace { _vi_mode_show_mode REPLACE; zle .vi-replace }
#zle -N {,_vi_mode-}vi-replace
#function _vi_mode-overwrite-mode { _vi_mode_show_mode OVERWRITE; zle .overwrite-mode }
#zle -N {,_vi_mode-}overwrite-mode
#
#function _vi_mode-zle-keymap-select {
#    local text
#    [[ $KEYMAP = vicmd ]] && text=NORMAL
#    [[ $KEYMAP = viins ]] && text=INSERT
#    _vi_mode_show_mode $text
#}
#autoload -Uz add-zle-hook-widget
#add-zle-hook-widget {,_vi_mode-zle-}keymap-select


# vim: sw=0 ts=4 sts=4 et
