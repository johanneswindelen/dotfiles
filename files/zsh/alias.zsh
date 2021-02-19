case $OSTYPE in
  darwin*)
    alias ll="ls -laG"
    alias ls="ls -G"
  ;;
  linux*)
    alias ll="ls -la --color=auto"
    alias ls="ls --color=auto"
  ;;
esac
alias grep="grep --color=auto"
alias gp="git symbolic-ref --short HEAD 2> /dev/null | xargs -L1 git push origin"
alias ssh="TERM=xterm-256color ssh"
