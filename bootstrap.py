#!/usr/bin/env python
#coding: utf-8
'''Usage:
    bootstrap.py ( install | update | remove ) [ -d ]
    bootstrap.py -h

Options:
    install     Install dotfiles
    update      Update dotfiles
    remove      Removes dotfiles restoring your backups (if they exist)
    -d          Test with the info passed to make sure is correct makes backup but do not override originals
    -h          This help
'''
from __future__ import print_function
from __future__ import unicode_literals
import os
import re
import sys
import shutil
import subprocess
try:
    from docopt import docopt
except:
    print('Please install docopt - pip install docopt')

__version__ = '0.2'

def info():
    info = {}

    if re.match(r'[Ll]inux', u' '.join(os.uname())):
        info.update({u'os': u'linux' })
    elif re.match(r'[Dd]arwin', u' '.join(os.uname())):
        info.update({u'os': u'mac' })
    else:
        print(u'Cannot determine what SO you are running')
        exit(1000)

    info.update({u'script_dir': os.path.realpath(os.path.dirname(sys.argv[0]))})
    info.update({u'home': os.environ[u'HOME']})

    _files = ['.bashrc', '.bash_profile', '.gitconfig', '.hushlogin', '.vimrc', '.dotfiles_config']

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
        isFile = 'file' if os.path.isfile(_src) else 'link destination do not exist'
        isLink = 'link' if os.path.islink(_src) else 'do not exist'
        print(u'{0}({2})\n\t-> {1}'.format(_src, _dst, ','.join([isLink, isFile])))
    print(u'{:<20}{:<20}'.format(u'Home dir:', info[u'home']))

def backup(info):
    _backup_dir = os.path.join(info[u'script_dir'], 'backup')
    if not os.path.exists(_backup_dir): os.mkdir(_backup_dir)
    with open(os.path.join(_backup_dir, 'backuplist.log'), u'w') as _backup_file:
        for _file in info[u'files']:
            _src = os.path.realpath(os.path.join(info[u'home'], _file)).strip()
            if os.path.exists(_src) and os.path.isfile(_src):
                _backup_file.write(u'{}\n'.format(_file))
                _dst = os.path.join(_backup_dir, _file).strip()
                print(u'Backing up {}'.format(_file))
                shutil.copy(_src, _dst)

def restore(info):
    _backup_dir = os.path.join(info[u'script_dir'], 'backup')
    with open(os.path.join(_backup_dir, 'backuplist.log'), u'r') as _backup_file:
        for _file in _backup_file.readlines():
            _file = _file.strip()
            _dst = os.path.realpath(os.path.join(info[u'home'], _file)).strip()
            if os.path.exists(_dst):
                _src = os.path.join(_backup_dir, _file).strip()
                print(u'Restoring file {}'.format(_file))
                #if not info[u'debug']: os.remove(_dst)
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
        if not info[u'debug'] and os.path.exists(_dst): os.remove(_dst)
        if not info[u'debug']: os.symlink(_src, _dst)

    with open(os.path.join(info[u'home'], u'.dotfiles_config'), u'a') as _file:
        if re.match(u'linux', info[u'os']):
            _file.write(u'_is_linux=true\n_is_mac=false\n')
        if re.match(u'mac', info[u'os']):
            _file.write(u'_is_mac=true\n_is_linux=false\n')

    install_pyenv()
    install_rbenv()

    print(u'''Installation finished.
run \'source ~/.bash_profile\' or open another terminal to see the changes.
If you are updating an existing installation you can run \'dotfiles_update\'''')

def choose(msg=u'Do you want to delete your config file?', choices={ u'y': True, u'n': False }, default=u'n'):
    _choice = u''
    while _choice.lower() not in choices.keys():
        try:
            _choices = u'/'.join(choices.keys())
            _choices = _choices.replace(default.lower(), default.upper())
            _choice = unicode(raw_input(u'{} ({}): '.format(msg, _choices).encode(u'utf-8')))
            _choice = default if _choice == u'' else _choice
            _choosen = choices[_choice[0].lower()]
        except Exception, e:
            _choice = u''
    return _choosen

def remove(info):
    print(info[u'files'])
    for _file in info[u'files']:
        _src = os.path.join(info[u'home'], _file)
        _answer = True
        if _file in [u'.dotfiles_config']:
            _answer = choose()
            if os.path.exists(_src) and os.path.isfile(_src) and _answer:
                print(u'Removing file {}'.format(_file))
                if not info[u'debug'] and os.path.exists(_src): os.remove(_src)
        elif os.path.exists(_src) and os.path.islink(_src) and _answer:
            print(u'Removing symlink to {}'.format(_file))
            if not info[u'debug'] and os.path.exists(_src): os.remove(_src)

    restore(info)

    print(u'''Removal completed.
Open another terminal to see the changes''')

def install_pyenv():
    _choice = choose(msg='Do you want to install pyenv?')
    if _choice:
        # subprocess.call()
        # curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
        pass

def install_rbenv():
    _choice = choose(msg='Do you want to install rbenv?')
    if _choice:
        # subprocess.call()
        # curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
        pass

def main():
    _info = info()
    args = docopt(__doc__)
    print(args)
    if args.has_key('-d') and args[u'-d']:
        _info.update({u'debug': True})
    else:
        _info.update({u'debug': False})

    if args.has_key('-d') and args[u'-d']:
        debug(_info)

    if args.has_key('install') and args[u'install']:
        install(_info)
    elif args.has_key('update') and args[u'update']:
        install(_info, args[u'update'])
    elif args.has_key('remove') and args[u'remove']:
        remove(_info)
    # elif args.has_key('-d') and args[u'-d']:
    #     debug(_info)



if __name__ == '__main__':
    main()
