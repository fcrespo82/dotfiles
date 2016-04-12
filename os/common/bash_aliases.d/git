# Git
# You must install Git first
if [ -x "$(which git 2> /dev/null)" ]; then
    alias gs='git status'
    alias ga='git add -i' # Interactive
    alias gu='git add -u :/' # Update Tracked files
    alias gaa='git add .'
    alias gc='git commit -m' # requires you to type a commit message
    alias gp='git push'
    alias gd="git diff"
    alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'
    eval "$(hub alias -s)"
fi