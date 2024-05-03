


# Install dependencies first?
sudo pacman -Sy --needed git base-devel coreutils
# Test if is installed before cloning
git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si
yay -Sy --noconfirm bat eza stow
# if [ ! -d "$HOME/powerlevel10k" ]; then
#     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
# fi
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
fi

stow --dotfiles .