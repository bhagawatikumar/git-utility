#!/usr/bin/env bash

RED='\033[01;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# get the script's directory
#CURRENT_DIR=`dirname $(readlink -f $0)`
#printf "$CURRENT_DIR \n"

# aliases
alias bb='git branch'
#alias cc='git checkout'
alias cc=cc
alias dd="git diff"

SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )

if [ -f $SCRIPT_DIR/.git_prompt.sh ]; then
    source $SCRIPT_DIR/.git_prompt.sh
fi

if [ -f $SCRIPT_DIR/.git-completion.bash ]; then
    source $SCRIPT_DIR/.git-completion.bash
    export PS1='\u:\[\033[00;32m\] \W$(__git_ps1 "[\[\033[00;36m\]%s\[\033[00;32m\]]")\[\033[00m\]$\[\033[00m\] '
#    export PS1='\[\033[00m\][\u@\h\[\033[00;32m\] \W$(__git_ps1 " \[\033[00;36m\](%s)")\[\033[00m\]]\$ '
#    export PS1='\[\033[00m\][\u@\h \W$(__git_ps1 " (\[\033[00;36m\]%s\[\033[00m\])")]\$ '
fi

function g {
    if [[ $# > 0 ]]; then
        git $@
    else
        git status
    fi
}

# To see oneline log of last 10 git commits
function gl {
    export LESS=eFRX
    if [[ $# > 0 ]]; then
        git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' -$@
    else
        git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' -10
#    git log --pretty=format:"%h - %an, %ar : %s" -10
  fi
}

# Allows commit message without typing quotes (can't have quotes in the commit msg though).
function gc {
   git commit -m "$*"
}

# add and commit assistant
function ac() {
    CUR_BRANCH=$(git symbolic-ref --short HEAD)
    JIRA=$(echo $CUR_BRANCH | egrep -o '[[:digit:]]*' | head -n1)

    # find the prefix and add it to JIRA
    local JIRA_PREFIX=$(echo $CUR_BRANCH | cut -d'/' -f 2 | cut -d'-' -f 1)
    JIRA=$(echo $JIRA_PREFIX | tr '[:lower:]' '[:upper:]')-$JIRA

    printf "${GREEN}Modified files:${RED} \n"
    g ls-files -m

#    read -p $'\e[32mFile           :\e[0m ' file
    printf "\n${GREEN}File           :${NC} "
    read -a file

    LEN=${#file[@]}
    if [ "$LEN" -eq 0 ]; then
        printf "${RED}No file added. Please add file(s) to be commited. Exiting... \n"
    else
        git add ${file[@]}

        if [ "$LEN" -eq 1 ]; then
            FNAME=${file[0]##*/}
            printf "${GREEN}Commit message :${NC} [$JIRA]--$FNAME--"
            read commit

            git commit -m "[$JIRA]--$FNAME--$commit"
        else
            printf "${GREEN}Commit message :${NC} [$JIRA]--"
            read commit

            git commit -m "[$JIRA]--$commit"
        fi

        printf "\n${GREEN}Commit logs: ${NC}\n"
        gl 6
    fi
}

# checkout assistance
function cc() {
#    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
#    git fetch --all
#    git pull --all

#    declare -a BRANCH_LIST

    # lets deal with the modified files first (handling single file at the moment)
    local modified_files=($(git ls-files -m))

    contains_file=0
    containsElement "$1" "$modified_files"
    if [[ "$contains_file" -eq 1 ]]; then
        git checkout $1
        return 0
    fi

    # dealing with the branch checkout now
    BRANCH_LIST=($(bb | grep "$*"))

    LENGTH=${#BRANCH_LIST[@]}

    if [ "$LENGTH" -eq 1 ]; then
        git checkout ${BRANCH_LIST[0]}
    elif [ "$LENGTH" -eq 0 ]; then
        git fetch origin
        REMOTE_BRANCH_LIST=($(bb -r| grep "$*"))
        REMOTE_LENGTH=${#REMOTE_BRANCH_LIST[@]}

        if [ "$REMOTE_LENGTH" -eq 1 ]; then
            REMOTE_BRANCH_LIST[0]=${REMOTE_BRANCH_LIST[0]:7}
            git checkout ${REMOTE_BRANCH_LIST[0]}
        elif [ "$REMOTE_LENGTH" -gt 1 ]; then
            printf "Multiple branches contain ${GREEN}\"$*\"${NC}, Please choose one:\n"
            bb -r| grep "$*"
        else
            printf "No branch exist for ${RED}\"$*\" \n"
        fi
    elif [ "$LENGTH" -gt 1 ]; then
        printf "Multiple branches contain ${GREEN}\"$*\"${NC}, Please choose one:\n"
        bb | grep "$*"
    else
        git checkout "$*"
    fi
}

if_branch_exists() {
    declare -a branch_array=("${!1}")
    echo "${branch_array[@]}"

    LENGTH=${#branch_array[@]}

    if [ "$LENGTH" -eq 1 ]; then
        git checkout ${branch_array[0]}
    elif [ "$LENGTH" -gt 1 ]; then
        printf "Multiple branches contain ${GREEN}\"$*\"${NC}, Please choose one:\n"
        bb | grep "$*"
    fi
}

# helper function to check if the array contains given element
# usage: containsElement "search_this" "$array_var_OR_array"
containsElement () {
    local e
    for e in "${@:2}"; do
        [[ "$e" == "$1" ]] && contains_file=1;
    done;
    return 0
}

unset check
unset SCRIPT_DIR

# git ls-remote origin | git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)' | sed 's/refs\/heads\///g'
