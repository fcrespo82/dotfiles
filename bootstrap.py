#!.venv/bin/python
'''usage:
    bootstrap.py [-d]

options:
    -d          Enable debug

'''
from pathlib import Path
from distutils.spawn import find_executable
import logging
import yaml
from docopt import docopt

VERSION = '1.0'


def verify_app(app):
    if app['type'] == 'folder':
        #pylint: disable=no-member
        return Path(app[app['type']]).expanduser().exists()
    else:
        if find_executable(app[app['type']]):
            return True
    return False


def verify_requirements(apps):
    logging.info('Checking for requirements')
    for app in apps:
        installed = verify_app(apps[app])
        apps[app]['installed'] = installed
        logging.debug('%s - installed: %s', app, installed)

    for app in apps:
        if not apps[app]['installed'] and apps[app]['required']:
            logging.fatal('\'%s\' is required but is not installed', app)
            return False
    return True


def main():
    logging.basicConfig(level=LOG_LEVEL)
    apps = yaml.load(open('apps.yaml'))
    ok = verify_requirements(apps)
    print(ok)


if __name__ == '__main__':
    PARAMS = docopt(__doc__, version=VERSION)
    LOG_LEVEL = logging.INFO
    if PARAMS['-d']:
        LOG_LEVEL = logging.DEBUG
    main()
