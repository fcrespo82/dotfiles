import subprocess

REQUIRED_APPS = {
    "openssl": {
        "os": "all"
    },
    "asdf": {
        "os": "all",
        "git": True,
        "path": "~"
    },
    "zplug": {
        "os": "all",
        "git": True,
        "function": True,
        "path": "~"
    }
}

def verify_requirements():
    for command in REQUIRED_APPS:
        which = subprocess.run(["which", command], stdout=subprocess.PIPE)
        if which.returncode == 0:
            if not REQUIRED_APPS[command].get('function'):
                REQUIRED_APPS[command]['real_path'] = which.stdout
            REQUIRED_APPS[command]['installed'] = True

    return REQUIRED_APPS

def main():
    print(verify_requirements())

if __name__ == '__main__':
    main()
