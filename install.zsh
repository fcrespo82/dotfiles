DRY_RUN=${DRY_RUN:-true}

export USER=$(find home -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | fzf)
export HOST=$(find hosts -mindepth 2 -maxdepth 2 -type d -printf '%P\n' | fzf)

PACMAN_FLAGS=(
    --needed
    --asexplicit
    --noconfirm
)

[ -s home/$USER/PACKAGES.sh ] && source home/$USER/PACKAGES.sh
[ -s hosts/$HOST/PACKAGES.sh ] && source hosts/$HOST/PACKAGES.sh

if [ "$DRY_RUN" = true ]; then
    echo "================================================================================"
    echo "=                                   DRY RUN                                    ="
    echo "================================================================================"
    echo
    echo "Installing on $USER@$HOST"
    echo
    echo "User packages: ${USER_PACKAGES[@]}"
    echo
    echo "System packages: ${SYSTEM_PACKAGES[@]}"
    echo
fi

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

run_command() {
    MESSAGE="$1"
    shift
    COMMAND="$@"
    gum spin --show-output --spinner line --title "$MESSAGE" -- $COMMAND && normal "$MESSAGE - $(success done)" || normal "$MESSAGE - $(error error)";
}

error() {
    gum style --foreground 1 "$1"
}
success() {
    gum style --foreground 2 "$1"
}
warn() {
    gum style --foreground 3 "$1"
}
info() {
    gum style --foreground 4 "$1"
}
normal() {
    gum style --foreground 255 "$1"
}


if [ "$DRY_RUN" = false ]; then
    sudo pacman -Sy ${PACMAN_FLAGS[@]} ${PRE_REQUISITES[@]}
fi

if [ "$DRY_RUN" = false ]; then
    sh home/$USER/hooks/pre-install
    sh hosts/$HOST/hooks/pre-install
else
    echo sh home/$USER/hooks/pre-install
    echo sh hosts/$HOST/hooks/pre-install
fi

if [ "$DRY_RUN" = false ]; then
    sudo pacman -Sy ${PACMAN_FLAGS[@]} ${SYSTEM_PACKAGES[@]}
else
    echo sudo pacman -Sy ${PACMAN_FLAGS[@]} ${SYSTEM_PACKAGES[@]}
fi

if [ "$DRY_RUN" = false ]; then
    if ! command -v yay >/dev/null 2>&1; then
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si
        yay -Sy ${PACMAN_FLAGS[@]} ${USER_PACKAGES[@]}
    else
        yay -Sy ${PACMAN_FLAGS[@]} ${USER_PACKAGES[@]}
    fi
else
    echo yay -Sy ${PACMAN_FLAGS[@]} ${USER_PACKAGES[@]}
fi

if [ "$DRY_RUN" = false ]; then
    if [ ! -d "$HOME/.config/zsh/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/themes/powerlevel10k
    fi
else
    echo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/themes/powerlevel10k
fi

# if [ ! -d "$HOME/.asdf" ]; then
#     git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
# fi


if [ "$DRY_RUN" = false ]; then
    stow -vv --dotfiles --dir=home --target=$HOME $USER
else
    echo stow -vv --dotfiles --dir=home --target=$HOME $USER
fi

# find hosts -mindepth 2 -maxdepth 2 -type d -not -name '.*' -printf '%f\n' \
# | fzf --preview-window up:80% --preview 'stow -n -vv --dir=hosts/personal --target=/ {}' \
# | xargs -ro sudo stow -vv --dir=hosts/personal --target=/


if [ "$DRY_RUN" = false ]; then
    sh home/$USER/hooks/post-install
    sh hosts/$HOST/hooks/post-install
else
    echo sh home/$USER/hooks/post-install
    echo sh hosts/$HOST/hooks/post-install
fi

# if [ "$DRY_RUN" = false ]; then
#     exec zsh
# fi