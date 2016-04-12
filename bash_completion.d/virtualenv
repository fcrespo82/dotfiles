_virtualenvs()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(command ls $VIRTUALENV_ROOT 2>/dev/null)"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

function workon() {
    source $VIRTUALENV_ROOT/$1/bin/activate
}

complete -F _virtualenvs workon
