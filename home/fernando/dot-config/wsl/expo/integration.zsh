[[ ! -z ${DEBUG+x} ]] && echo "Configuring ip for expo"
# Since my ip is static, declare it here
# This config helps metro and wslhostpatcher find expo server when using Expo Go

# TODO: Make this work fot both ethernet and wifi
export REACT_NATIVE_PACKAGER_HOSTNAME=$(ipconfig.exe | grep -a -A5 "Ethernet:" | grep -a "IPv4" | grep -a --color -oE "([0-9]{1,3}\.?){4}")