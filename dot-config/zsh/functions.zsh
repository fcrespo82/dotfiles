pgrep_full() {
    command pgrep -fla $@ | grep --color -E "^[0-9]+"
}

ls-count-grouped-by-extensions() {
  ONLY_LOCAL='1'
  if [ "$1" = "-h" ]; then
    echo "Usage: $0 [options] <path>"
    echo ""
    echo "path  Optional path to look for, if not passed assumes ."
    echo "-h    Show this help"
    echo "-r    List extensions count recursively"
    shift
    return
  fi
  if [ "$1" = "-r" ]; then
    ONLY_LOCAL="99999"
    shift
  fi
  local SEARCH_PATH=$1
  find $SEARCH_PATH -maxdepth $ONLY_LOCAL -type f | perl -ne 'print lc($1) if m/\.([^.\/]+)$/' | sort | uniq -c | sort -n | grep --color \d+
}
alias lse=ls-count-grouped-by-extensions

count() {
    if [ -z "$1" ]; then
        ls -1 | wc -l | sed "s/ //g"
    else
        while getopts ":a" arg; do
            case "$arg" in
                a) ls -A1 | wc -l | sed "s/ //g";;
                \?) echo -e "Usage:\n\tcount   \tCount files in a folder (except hidden)\n\tcount -a\tCount files in a folder including hidden";;
            esac
            shift $((OPTIND-1))
        done
    fi
}