# set a color, if it already exists add a separator
# https://jonasjacek.github.io/colors/
colored() {
    local text="$1"
    local fg="$2"
    local bg="$3"

    # Create full ANSII format with color reset
    echo "%{\e[38;5;${fg};48;5;${bg}m%}$1%{\e[0m%}"
}

# Current version control status
vcs() {
    # Exit if not in git dir
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
        return
    fi

    # Set branch name
    local branch=$(git symbolic-ref --short HEAD 2> /dev/null)

    # Check if there is new stuff to commit
    if [[ -n $(git rev-list "$branch"@{upstream}..HEAD 2> /dev/null) ]]; then
        local push=" ↑"
    fi

    # Get color based on directory status
    if [[ -n $(git status --porcelain) ]]; then
        echo $(colored " ($branch$push)" 9 0)
    else
    	echo $(colored " ($branch$push)" 10 0)
    fi
}

returns() {
    local code
    if [ $? -eq 0 ]; then
        code=$(colored " ✓ " 10 22)
	echo $code
    else
        code=$(colored "𐄂%? " 9 52)
	echo ${(l:4:)code}
    fi
    echo ${(l:4:)code}	
}

path() {
    echo $(colored " %5~ " 15 232)
}

precmd() {
    PROMPT="$(returns)$(path)$(vcs) %# "
}

