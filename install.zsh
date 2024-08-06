

SYSTEM_PACKAGES=(
    ark
    base
    base-devel
    btrfs-progs
    dkms
    dolphin
    efibootmgr
    egl-wayland
    fzf
    git
    gst-plugin-pipewire
    htop
    intel-ucode
    iwd
    kate
    konsole
    less
    lib32-nvidia-utils
    libpulse
    linux
    linux-firmware
    linux-headers
    man-db
    man-pages
    nano
    network-manager-applet
    networkmanager
    nvidia-dkms
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    plasma-meta
    plasma-workspace
    plymouth
    smartmontools
    sof-firmware
    stow
    vim
    wget
    wireless_tools
    wireplumber
    xdg-utils
    xorg-xeyes
    xorg-xinit
    zram-generator
    zsh
)

USER_PACKAGES=(
    1password
    apple-fonts
    bat
    chromedriver
    eza
    google-chrome
    stow
    trash-cli
    visual-studio-code-bin
    zsh-autosuggestions
    konsole-dracula-git
)

PACMAN_FLAGS=(
    --needed
    --asexplicit
    --noconfirm
)

# Install dependencies first?
sudo pacman -Sy ${PACMAN_FLAGS[@]} ${SYSTEM_PACKAGES[@]}


if ! command -v yay >/dev/null 2>&1; then
    # Test if is installed before cloning
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si
else
    yay -Sy ${PACMAN_FLAGS[@]} ${USER_PACKAGES[@]}
fi


if [ ! -d "$HOME/.config/zsh/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/themes/powerlevel10k
fi
# if [ ! -d "$HOME/.asdf" ]; then
#     git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
# fi


find home -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' \
| fzf  --multi --preview-window up:80% --preview 'stow -n -vv --dotfiles --dir=home --target=$HOME {}' \
| xargs -ro stow -vv --dotfiles --dir=home --target=$HOME


find hosts -mindepth 2 -maxdepth 2 -type d -not -name '.*' -printf '%f\n' \
| fzf  --multi --preview-window up:80% --preview 'stow -n -vv --dir=hosts/personal --target=/ {}' \
| xargs -ro sudo stow -vv --dir=hosts/personal --target=/

sudo systemd-hwdb update
sudo udevadm trigger

exec zsh