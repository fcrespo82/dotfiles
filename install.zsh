#! /usr/bin/env zsh

DRY_RUN=$(gum choose --header "Dry run?" true false)

PACMAN_FLAGS=(
    --needed
    --asexplicit
    --noconfirm
)

STOW_FLAGS=(
    --no-folding
    -vv 
)

PRE_REQUISITES=(
    base-devel
    ca-certificates
    coreutils
    fzf
    git
    gum
    less
    tk
    unzip
    wget
)

if [ "$DRY_RUN" = false ]; then
    sudo pacman -Sy ${PACMAN_FLAGS[@]} ${PRE_REQUISITES[@]}
fi

log-error() {
    gum style --foreground 1 "$@"
}
log-success() {
    gum style --foreground 2 "$@"
}
log-warn() {
    gum style --foreground 3 "$@"
}
log-info() {
    gum style --foreground 4 "$@"
}
log-normal() {
    gum style --foreground 255 "$@"
}

export INSTALLATION_USER=$(find home -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | fzf)
export INSTALLATION_HOST=$(find hosts -mindepth 2 -maxdepth 2 -type d -printf '%P\n' | fzf)

[ -s home/$INSTALLATION_USER/pkgconfig ] && source home/$INSTALLATION_USER/pkgconfig
[ -s hosts/$INSTALLATION_HOST/pkgconfig ] && source hosts/$INSTALLATION_HOST/pkgconfig

if [ "$DRY_RUN" = true ]; then
    gum style --padding 1 --border double --foreground 1 --border-foreground 1 --width 80 --align center --bold "DRY RUN"

fi

log-info "Installing for"
user-info
host-info

if [ "$DRY_RUN" = false ]; then
    gum confirm "Continue?" || exit
fi

user-pre-install
host-pre-install

user-install
host-install

user-post-install
host-post-install
