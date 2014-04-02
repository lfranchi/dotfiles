# load shared shell configuration
source ~/.shrc

# Load git-prompt
source ~/src/zsh-git-prompt/zshrc.sh

# Enable advanced completion
autoload -U compinit && compinit

# Enable regex moving
autoload -U zmv

# delete one word at a time when deleting
autoload -Uz select-word-style
select-word-style bash

# rbenv and  autocompletion
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
source /usr/local/Cellar/rbenv/0.4.0/completions/rbenv.zsh

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Change to directory by just entering name
setopt auto_cd

# Don't show duplicate history entires
setopt hist_find_no_dups

# Remove unnecessary blanks from history
setopt hist_reduce_blanks

# Share history between instances
#setopt share_history

# Don't hang up background jobs
setopt no_hup

# Expand parameters, commands and aritmatic in prompts
setopt prompt_subst

# Colorful prompt with Git and Subversion branch
autoload -U colors && colors

function precmd() {
    if [ "$(id -u)" -ne 0 ]; then
        FULL_CMD_LOG="$HOME/.zsh-logs/zsh-history-$(date -u "+%Y-%m-%d").log"
        echo "$USER@`hostname`:`pwd` [$(date -u)] `\history -1`" >> ${FULL_CMD_LOG}
    fi
}

git_branch() {
	BRANCH_REFS=$(git symbolic-ref HEAD 2>/dev/null) || return
	echo "(${BRANCH_REFS#refs/heads/}) "
}

svn_branch() {
	[ -d .svn ] || return
	SVN_INFO=$(svn info 2>/dev/null) || return
	SVN_BRANCH=$(echo $SVN_INFO | grep URL: | grep -oe '\(trunk\|branches/[^/]\+\|tags/[^/]\+\)')
	[ -n "$SVN_BRANCH" ] || return
	# Display tags intentionally so we don't write to them by mistake
	echo "(${SVN_BRANCH#branches/}) "
}

local bolt="`printf '\xE2\x9A\xA1\x0A'`"
local heart="`printf '\xE2\x99\xA4'`"

if [[ $USER == "root" ]]
then
	PROMPT='%{$fg_bold[magenta]%}%m %{$fg_bold[blue]%}# %b%f'
elif [ -n "${SSH_CONNECTION}" ]
then
	PROMPT='%{$fg_bold[cyan]%}%m %{$fg_bold[blue]%}# %b%f'
else
	PROMPT='%{$fg_bold[green]%}%m %{$fg_bold[blue]%}${heart} %b%f'
fi
RPROMPT='%{$fg_bold[red]%}$(git_super_status)%{$fg_bold[yellow]%}$(svn_branch)%b[%{$fg_bold[blue]%}%~%b%f]'

# History
export HISTSIZE=9999999
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

# use emacs bindings even with vim as EDITOR
bindkey -e

# fix backspace on Debian
bindkey "^?" backward-delete-char

# allow the use of the Delete/Insert keys
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert

# alternate mappings for Ctrl-U/V to search the history
bindkey "^u" history-beginning-search-backward
bindkey "^v" history-beginning-search-forward

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
