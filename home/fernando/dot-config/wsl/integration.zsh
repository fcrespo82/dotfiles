[[ ! -z ${DEBUG+x} ]] && echo "Starting WSL HostPatcher"

# Run wslpatcher
if [ -e /mnt/d/wsl/WSLHostPatcher/WSLHostPatcher.exe ]; then
    /mnt/d/wsl/WSLHostPatcher/WSLHostPatcher.exe > /dev/null
else
    echo "WSLHostPatcher.exe not found"
    echo Get it from https://github.com/CzBiX/WSLHostPatcher/releases
fi
