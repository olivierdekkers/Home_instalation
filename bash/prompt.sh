# A two-line colored Bash prompt (PS1) with some version control
# system prompts (git, mercurial, svn adn fossil) aligned to the right.
# Author: Michal Kottman, 2012
# Contributor: Eduardo Lezcano, 2016
 
RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\033[01;33m\]"
D_YELLOW="\[\033[0;33m\]"

function vcs_prompt {
if [ -d .git ]; then
	ref=$(git symbolic-ref HEAD 2> /dev/null)
	PS_VCS_SERVICE="git"
	PS_VCS_BRANCH="${ref#refs/heads/}"
elif [ -d .svn ]; then
	PS_VCS_SERVICE="svn"
	PS_VCS_BRANCH="$(svn info|awk '/Revision/{print $2}')"
elif [ -d .hg ]; then
	PS_VCS_SERVICE="hg"
	PS_VCS_BRANCH="$(hg branch)"
elif [ -f _FOSSIL_ -o -f .fslckout ]; then
	PS_VCS_SERVICE="fossil"
	PS_VCS_BRANCH="$(fossil status|awk '/tags/{print $2}')"
else
	PS_VCS_SERVICE=''
	PS_VCS_BRANCH=''
fi
}

PROMPT_COMMAND=vcs_prompt

PS_BRANCH="$D_YELLOW\$PS_VCS_SERVICE $YELLOW\$PS_VCS_BRANCH"
PS_BRANCH_SIZE="\${#PS_VCS_SERVICE}-\${#PS_VCS_BRANCH}"
PS_VCS="\[\033[\$((COLUMNS-1-$PS_BRANCH_SIZE))G\] $YELLOW$PS_BRANCH"

PS_INFO="$GREEN\u@\h$RESET:$BLUE\w"

export PS1="\[\033[0G\]${PS_INFO} ${PS_VCS}\n${RESET}\$ "
