function pgrep() {
    command pgrep -fa $@ | egrep ^[0-9]+
}