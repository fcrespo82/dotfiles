_repos()
{
    local cur prev opts
    COMPREPLY=()

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="$(command github.py 2>/dev/null)"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _repos git -a clone

complete -F _repos git-clone
