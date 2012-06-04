# ------- OPTIONS --------------------------------------------------
setopt auto_menu
#setopt ksh_autoload

# Ne pas augmenter le nice des processus lances en bg avec '&'
setopt no_bg_nice

# demander confirmation apres une commande bang-history
setopt HIST_VERIFY

# gestion des doubles dans l'historique
setopt HIST_SAVE_NO_DUPS HIST_FIND_NO_DUPS

# divers historique
setopt no_hist_beep append_history

# activation de = en tete pour remplacer which
setopt equals

# do not send SIGHUP to background processes when shells are closed
setopt nohup

# divers
setopt nobeep
setopt auto_cd cdable_vars auto_pushd
setopt extended_glob
setopt numeric_glob_sort

# -------- USER-DEFINED FUNCTIONS ----------------------------------
autoload_custom_functions() 
{
    [[ -d $HOME/.zsh/functions ]] || return

    setopt extendedglob
    [[ $fpath = *$HOME/.zsh/functions* ]] || fpath=($HOME/.zsh/functions $fpath)

    autoload -U ${fpath[1]}/^*.zwc(:tN)
}
autoload_custom_functions

zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' ignore-parents pwd ..
zstyle ':completion:*:complete:kill:*' command 'ps -x -k command'
# -------- AUTOCOMPLETE ---------------------------------------------
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _prefix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose 'true'
zstyle ':completion:*' list-grouped 'true'
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select=0 select=long-list 
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/doudou/.zshrc'

autoload -U compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' use-cache 'true'
zstyle ':completion:*' use-perl 'true'

# valgrind does not work sometimes :(
zstyle ':completion:*:insmod:*' file-patterns '*.ko' '*(-/)'

autoload -U incremental-complete-word
zle -N incremental-complete-word

# Make sure we are in emacs mode
bindkey -e
bindkey '^Xi' incremental-complete-word
bindkey '^X?' _complete_debug
bindkey '^Xm' _most_recent_file

# -------- Misc keybidings
bindkey '^[Q' push-line-or-edit
bindkey '^[q' push-line-or-edit

# -------- Misc zstyles
# Show path-directories last, they are pretty annoying
zstyle ':completion:*:cd:*' tag-order local-directories path-directories

# -------- Host-based completion
if (( ${+functions[_load_hosts]} )); then
    _load_hosts
    zstyle ':completion:*:hosts' group-name hosts
    zstyle ':completion:*:users' group-name users
    zstyle ':completion:*:*:ssh:*' group-order hosts users
    zstyle ':completion:*:hosts' hosts $known_hosts
    zstyle ':completion:*:complete:ping:*:hosts' hosts $known_hosts
fi

# -------- svn completion
#  zstyle ':completion:*:svn*' use-cache 'true'
#
zstyle ':completion:*:svn*' list-colors ''
zstyle ':completion:*:svn*' remote-access 'true'
zstyle ':completion:*:svn*' repositories $svnpath

# -------- ALIASES --------------------------------------------------
alias ls="ls -l"
alias diff="diff -u -p -N"
alias mmplayer="mplayer -ao null -fs -fixed-vo"
alias psg="ps aux | grep "
alias pst="ps f -e -o 'user,pid,vsz,rss,%mem,tname,start,time,command'"

alias ls='ls --color -h'
alias ll='ls -l -h'
alias du='du -h'
alias df='df -h'
alias free='free -m'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

umask 002

HISTFILE=${HOME}/.history
SAVEHIST=200
HISTSIZE=500

if [ -f $HOME/.zsh/prompt ]; then
  . $HOME/.zsh/prompt
fi

