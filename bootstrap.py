#!.venv/bin/python
'''usage:
    bootstrap.py [-d] (install [--no-backup]|remove)
    bootstrap.py -h|--help

options:
    -d              Enable debug
    install         Install dotfiles
    --no-backup     Do NOT Backup files before install
    remove          Remove dotfiles
    -h|--help       Show this help
'''
import logging
from lib import Config, Installation
import yaml
from docopt import docopt
import coloredlogs

VERSION = '1.0'


def main():
    _log = logging.getLogger()
    apps = yaml.load(open('apps.yml'))
    files = yaml.load(open('files.yml'))

    _log.info('Loading config')
    cfg = Config(apps, files, PARAMS['install'], PARAMS['--no-backup'])
    inst = Installation(cfg)

    inst.perform()


if __name__ == '__main__':
    PARAMS = docopt(__doc__, version=VERSION)
    print(PARAMS)
    LOG_LEVEL = logging.INFO
    if PARAMS['-d']:
        LOG_LEVEL = logging.DEBUG
    coloredlogs.install(level=LOG_LEVEL)
    logging.basicConfig(level=LOG_LEVEL)
    main()
