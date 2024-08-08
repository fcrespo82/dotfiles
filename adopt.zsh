
find home -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' \
| fzf --preview-window up:80% --preview 'stow -n -vv --adopt --dotfiles --dir=home --target=$HOME {}' \
| xargs -ro stow -vv --adopt --dotfiles --dir=home --target=$HOME


# Use find to list all files that should be adoped
# Touch an empty file to inform that you want to adopt it
# FIX: Should  check if file exists in SOURCE

find hosts -mindepth 2 -maxdepth 2 -type d -printf '%P\n' \
| fzf --preview-window up:80% --preview 'find hosts/{} -mindepth 2 -type f -empty -printf "%P\n"' \
| xargs -ro -I{} find hosts/{} -mindepth 2 -type f -empty -printf "%P\n" \
| xargs -ro -I{} sudo cp -p /{} ./{}