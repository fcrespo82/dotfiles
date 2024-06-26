


# Install dependencies first?
sudo pacman -Sy --needed git base-devel coreutils tk less ca-certificates fzf wget unzip

if ! command -v yay >/dev/null 2>&1; then
    # Test if is installed before cloning
    git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si
    yay -Sy --noconfirm bat eza stow zsh-autosuggestions
fi

if [[ ! $(echo $(uname -r) | tr '[:upper:]' '[:lower:]') =~ microsoft ]]; then
    # Não é WSL
    yay -Sy --noconfirm 1password
fi

if [ ! -d "$HOME/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
fi
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
fi

stow --dotfiles .