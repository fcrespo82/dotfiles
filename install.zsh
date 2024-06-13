


# Install dependencies first?
sudo pacman -Sy --needed git base-devel coreutils tk less

if command -v bun >/dev/null 2>&1; then
    # Test if is installed before cloning
    git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si
    yay -Sy --noconfirm bat eza stow zsh-autosuggestions 1password
fi

if [ ! -d "$HOME/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
fi
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
fi

stow --dotfiles .