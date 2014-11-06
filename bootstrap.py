#!/usr/bin/env python
#coding: utf-8
'''Usage:
    bootstrap.py ( install | update | remove | test ) [ -force_ext ] [ -d ]
    bootstrap.py -h

Options:
    install     Install dotfiles
    update      Update dotfiles
    remove      Removes dotfiles restoring your backups (if they exist)
    -d          Test with the info passed to make sure is correct makes backup but do not override originals
    -h          This help
    -force_ext  rbenv, pyenv, powerline-shell, all
'''
from __future__ import print_function
from __future__ import unicode_literals
import os
import re
import sys
import shutil
import subprocess
import logging
try:
    import coloredlogs
except:
    logging.warning('Please install coloredlogs - pip install coloredlogs')

try:
    from docopt import docopt
except:
    logging.critical('Please install docopt - pip install docopt')
    exit(1)

__version__ = '1.0'

class MyInfo(object):
    """docstring for MyInfo"""
    def __init__(self):
        import re
        import os
        import sys
        import logging
        super(MyInfo, self).__init__()

        if 'linux'.lower() in map(str.lower, os.uname()):
            self.os = 'linux'
        elif 'darwin'.lower() in map(str.lower, os.uname()):
            self.os = 'mac'
        else:
            logging.critical('Cannot determine what SO you are running')

        self.script_dir = os.path.realpath(os.path.dirname(sys.argv[0]))
        self.home = os.environ['HOME']
        self.files = ['.bashrc', '.bash_profile', '.gitconfig', '.hushlogin', '.vimrc']

        # Verificar se tem um melhor modo de tratar especificidades de plataforma
        if 'linux' in self.os:
            self.files.extend(['linux.sh'])
        if 'mac' in self.os:
            self.files.extend(['mac.sh'])

        self.debug = False
        self.log_level = logging.INFO

def debug(info):
    logging.debug('{} {}'.format('Script dir:', info.script_dir))
    logging.debug('{} {}'.format('OS:', info.os))
    text = 'Files that will be linked:'
    for _file in info.files:
        _src = os.path.join(info.home, _file)
        _dst = os.path.join(info.script_dir, _file)
        isFile = 'file' if os.path.isfile(_src) else 'link destination do not exist'
        isLink = 'link' if os.path.islink(_src) else 'do not exist'
        text += '\n{0} ({2})\n\t-> {1}'.format(_src, _dst, ','.join([isLink, isFile]))
    text += '\n{:<20}{:<20}'.format('Home dir:', info.home)
    logging.debug(text)

def backup(info):
    text = 'Backing up files'
    from datetime import datetime
    _backup_dir = os.path.join(info.script_dir, 'backup-{}'.format(datetime.strftime(datetime.now(), '%Y.%m.%d-%H.%M.%S')))
    if not os.path.exists(_backup_dir): os.mkdir(_backup_dir)
    with open(os.path.join(_backup_dir, 'backuplist.log'), 'w') as _backup_file:
        for _file in info.files:
            _src = os.path.realpath(os.path.join(info.home, _file)).strip()
            if os.path.exists(_src) and os.path.isfile(_src):

                _backup_file.write('{}\n'.format(_file))
                _dst = os.path.join(_backup_dir, _file).strip()
                text += '\n' + os.path.join('~', _file)
                logging.debug('Copying ' + _src)
                logging.debug('to ' + _dst)
                shutil.copy(_src, _dst)
    logging.info(text)

def restore(info):
    _backup_dir = os.path.join(info.script_dir, 'backup')
    with open(os.path.join(_backup_dir, 'backuplist.log'), 'r') as _backup_file:
        for _file in _backup_file.readlines():
            _file = _file.strip()
            _dst = os.path.realpath(os.path.join(info.home, _file)).strip()
            if os.path.exists(_dst):
                _src = os.path.join(_backup_dir, _file).strip()
                logging.info('Restoring file {}'.format(_file))
                if not info['debug']: shutil.copy(_src, _dst)

def install(info, update=False):
    aborted = False

    backup(info)

    text = 'Creating symlinks'
    for _file in info.files:
        _src = os.path.join(info.script_dir, _file)
        _dst = os.path.join(info.home, _file)
        _src_log = os.path.join('<DOTFILES_DIR>', _file)
        _dst_log = os.path.join('~', _file)
        text += '\n{:<40} -> {:<30}'.format(_src_log, _dst_log)
        if not info.debug and os.path.exists(_dst): os.remove(_dst)
        if not info.debug: os.symlink(_src, _dst)

    logging.info(text)

    logging.info('''Installation finished.
run \'source ~/.bash_profile\' or open another terminal to see the changes.
If you are updating an existing installation you can run \'update-dotfiles\'''')

def choose(msg='Do you want to delete your config file?', choices={ 'y': True, 'n': False }, default='n'):
    _choice = ''
    while _choice.lower() not in choices.keys():
        try:
            _choices = '/'.join(choices.keys())
            _choices = _choices.replace(default.lower(), default.upper())
            _choice = unicode(raw_input('{} ({}): '.format(msg, _choices).encode('utf-8')))
            _choice = default if _choice == '' else _choice
            _choosen = choices[_choice[0].lower()]
        except Exception, e:
            _choice = ''
    return _choosen

def remove(info):
    print(info.files)
    for _file in info.files:
        _src = os.path.join(info.home, _file)
        _answer = True
        if os.path.exists(_src) and os.path.islink(_src) and _answer:
            print('Removing symlink to {}'.format(_file))
            if not info.debug and os.path.exists(_src): os.remove(_src)

    restore(info)

    logging.info('Removal completed.\nOpen another terminal to see the changes')

def install_powerline_shell():
    _choice = choose(msg='Do you want to install powerline-shell?')
    if _choice:
        # git submodule init
        # subprocess.call()
        # ./powerline-shell/install.py
        # _src = ./powerline-shell/powerline-shell.py
        # _dst = ~/powerline-shell.py
        # os.symlink(_src, _dst)
        pass

def install_homebrew():
    _choice = choose(msg='Do you want to install powerline-shell?')
    if _choice:
        # subprocess.call()
        pass

def main():
    _info = MyInfo()
    args = docopt(__doc__)

    if args.has_key('-d') and args['-d'] or (args.has_key('test') and args['test']):
        _info.debug = True
        _info.log_level = logging.DEBUG
    else:
        _info.log_level = logging.INFO

    try:
        coloredlogs.install(show_hostname=False, show_name=False, level=_info.log_level)
    except:
        logging.basicConfig(level=_info.log_level)

    logging.debug('Passed arguments: {}'.format(args))

    if args.has_key('-d') and args['-d']:
        debug(_info)

    if args.has_key('install') and args['install']:
        install(_info)
    elif args.has_key('update') and args['update']:
        install(_info, args['update'])
    elif args.has_key('remove') and args['remove']:
        remove(_info)
    elif args.has_key('test') and args['test']:
        debug(_info)

if __name__ == '__main__':
    main()
