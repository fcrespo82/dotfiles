
find home -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' \
| fzf --preview-window up:80% --preview 'stow -n -vv --adopt --dotfiles --dir=home --target=$HOME {}' \
| xargs -ro stow -vv --adopt --dotfiles --dir=home --target=$HOME


find hosts -mindepth 2 -maxdepth 2 -type d -printf '%P\n' \
| fzf --preview-window up:80% --preview 'stow -n -vv --adopt --dir=hosts/{} --target=/ .' \
| xargs -ro sudo stow -vv --adopt --dir=hosts/{} --target=/ .
