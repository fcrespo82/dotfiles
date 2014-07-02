#!/usr/bin/env python
'''usage:
bootstrap.py ( -i [ update ]  | -r | -d ) [ -t  -h ]

options:
-i     Install dotfiles
-u     Update dotfiles
-r     Removes dotfiles restoring your backups (if they exist)
-d     Debug the info passed to make sure is correct
-t     Test with the info passed to make sure is correct makes backup but do not override originals
-h     This help
'''

from __future__ import print_function
import os
import re
import sys
import shutil
from docopt import docopt

def info():
    info = {}

    if re.match(r'[Ll]inux', u' '.join(os.uname())):
        info.update({u'os': u'linux' })
    elif re.match(r'[Dd]arwin', u' '.join(os.uname())):
        info.update({u'os': u'mac' })
    else:
        print("Cannot determine what SO you are running")
        exit(1000)

    info.update({u'script_dir': os.path.realpath(os.path.dirname(sys.argv[0])) })
    info.update({u'home': os.environ[u'HOME'] })

    _files = ['.bashrc', '.bash_profile', '.gitconfig', 'z.sh', '.hushlogin', '.vimrc', '.dotfiles_config']
    if re.match(u'linux', info[u'os']):
        _files.extend(['.bash_profile_linux'])
    if re.match(u'mac', info[u'os']):
        _files.extend(['.bash_profile_mac'])
    info.update({u'files': _files })
    return info

def debug(info):
    print(u'{:<20}{:<20}'.format(u'Script dir:', info[u'script_dir']))
    print(u'{:<20}{:<20}'.format(u'OS:', info[u'os']))
    print("Files that will be linked:")
    for _file in info[u'files']:
        _src = os.path.join(info[u'home'], _file)
        _dst = os.path.join(info[u'script_dir'], _file)
        print(u'{}\n\t-> {}'.format(_src, _dst))
    print(u'{:<20}{:<20}'.format(u'Home dir:', info[u'home']))

def backup(info):
    _backup_dir = os.path.join(info[u'script_dir'], 'backup')
    if not os.path.exists(_backup_dir): os.mkdir(_backup_dir)
    with open(os.path.join(_backup_dir, 'backuplist.log'), u'w') as _backup_file:
        for _file in info[u'files']:
            _src = os.path.realpath(os.path.join(info[u'home'], _file))
            if os.path.exists(_src) and os.path.isfile(_src):
                _backup_file.write(u'{}\n'.format(_file))
                _dst = os.path.join(_backup_dir, _file)
                print(u'Backing up {}'.format(_file))
                shutil.copy(_src, _dst)

def restore(info):
    _backup_dir = os.path.join(info[u'script_dir'], 'backup')
    with open(os.path.join(_backup_dir, 'backuplist.log'), u'r') as _backup_file:
        for _file in _backup_file.readlines():
            _dst = os.path.realpath(os.path.join(info[u'home'], _file))
            if os.path.exists(_src) and os.path.isfile(_src):
                _backup_file.write(_file)
                _src = os.path.join(_backup_dir, _file)
                print(u'Restoring file {}'.format(_file))
                if not info[u'debug']: os.remove(_dst)
                if not info[u'debug']: shutil.move(_src, _dst)

def install(info, update=False):
    if not update:
        for _file in info[u'files']:
            _src = os.path.join(info[u'home'], _file)
            if os.path.exists(_src) and os.path.islink(_src):
                print(u'''Symlink to \'{}\' ALREADY exist, aborting.
If you want to update your installation run with 'update' option'''.format(_src))
                exit(1001)

    backup(info)

    print(u'Creating symlinks')
    for _file in info[u'files']:
        _src = os.path.join(info[u'script_dir'], _file)
        _dst = os.path.join(info[u'home'], _file)
        print(u'{}\n\t-> {}'.format(_src, _dst))
        if not info[u'debug']: os.symlink(_src, _dst)

    print('''Installation finished.
run \'source ~/.bash_profile\' or open another terminal to see the changes.
If you are updating an existing installation you can run \'dotfiles_update\'''')

def choose(msg=u'Do you want to delete your config file?', choices={ u'y': True, u'n': False }, default=u'n'):
    _choice = u''
    while _choice.lower() not in [ u'y', u'n' ]:

        try:
            _choices = '/'.join(choices.keys())
            # TODO: Uppercase default
            _choice = raw_input(u'{} ({} default={}): ', msg, _choices, default)
            _choice = default if _choice == u'' else _choice
            _choosen = choices[_choice[0].lower()]
        except Exception, e:
            _choice = u''
    return _choosen

def remove(info):
    for _file in info[u'files']:
        if _file in [u'.dotfiles_config']:


        if os.path.exists(_file) and os.path.islink(_file):
            _src = os.path.join(info[u'home'], _file)
            print(u'Removing symlink to {}'.format(_file))
            if not info[u'debug']: os.remove(_src)

        restore(info)

        PS3="Do you want to delete your config file? "
        options=("Yes" "No")
        select opt in "${options[@]}"
        do
            case $opt in
                ("Yes") rm -f "${HOME}"/.dotfiles_config; break ;;
                ("No") echo "${GREEN}Your config is under ${HOME}/.dotfiles_config${RESET}"; break ;;
                (*) echo invalid option ;;
            esac
        done
    done
    echo "${GREEN}Removal completed.${RESET}
Open another terminal to see the changes"
}

def main():
    _info = info()
    args = docopt(__doc__)
    print(args)
    if args[u'-t']: _info.update({u'debug': True})
    if args[u'-i']: install(_info, args[u'update'])
    elif args[u'-r']: remove()
    elif args[u'-d']: debug(_info)

if __name__ == '__main__':
    main()