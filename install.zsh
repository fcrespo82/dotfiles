DRY_RUN=${DRY_RUN:-true}

export USER=$(find home -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | fzf)
host=$(find hosts -mindepth 2 -maxdepth 2 -type d -printf '%P\n' | fzf)

PACMAN_FLAGS=(
    --needed
    --asexplicit
    --noconfirm
)

source home/$USER/PACKAGES.sh
source hosts/$host/PACKAGES.sh

if [ "$DRY_RUN" = true ]; then
    echo "================================================================================"
    echo "=                                   DRY RUN                                    ="
    echo "================================================================================"
    echo
    echo "Installing on $USER@$host"
    echo
    echo "User packages: ${USER_PACKAGES[@]}"
    echo
    echo "System packages: ${SYSTEM_PACKAGES[@]}"
    echo
fi

if [ "$DRY_RUN" = false ]; then
    sh home/$USER/hooks/pre-install
else
    echo sh home/$USER/hooks/pre-install
    echo
fi

if [ "$DRY_RUN" = false ]; then
    sudo pacman -Sy ${PACMAN_FLAGS[@]} ${SYSTEM_PACKAGES[@]}
else
    echo sudo pacman -Sy ${PACMAN_FLAGS[@]} ${SYSTEM_PACKAGES[@]}
    echo
fi

if [ "$DRY_RUN" = false ]; then
    if ! command -v yay >/dev/null 2>&1; then
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si
    else
        yay -Sy ${PACMAN_FLAGS[@]} ${USER_PACKAGES[@]}
    fi
else
    echo yay -Sy ${PACMAN_FLAGS[@]} ${USER_PACKAGES[@]}
    echo
fi

if [ "$DRY_RUN" = false ]; then
    if [ ! -d "$HOME/.config/zsh/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/themes/powerlevel10k
    fi
else
    echo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/themes/powerlevel10k
    echo
fi

# if [ ! -d "$HOME/.asdf" ]; then
#     git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
# fi


if [ "$DRY_RUN" = false ]; then
    stow -vv --dotfiles --dir=home --target=$HOME $USER
else
    echo stow -vv --dotfiles --dir=home --target=$HOME $USER
    echo
fi

# find hosts -mindepth 2 -maxdepth 2 -type d -not -name '.*' -printf '%f\n' \
# | fzf --preview-window up:80% --preview 'stow -n -vv --dir=hosts/personal --target=/ {}' \
# | xargs -ro sudo stow -vv --dir=hosts/personal --target=/


if [ "$DRY_RUN" = false ]; then
    sh home/$USER/hooks/post-install
else
    echo sh home/$USER/hooks/post-install
    echo
fi

if [ "$DRY_RUN" = false ]; then
    exec zsh
fi