import os
import logging
from pathlib import Path
from distutils.spawn import find_executable


class Config(object):
    def __init__(self, apps, files, install_type='install', no_backup=True):
        self._logger = logging.getLogger(__name__)
        self.shell = os.path.basename(os.environ['SHELL'])
        self.apps = apps
        self.files = files
        self.requirements_ok = self._verify_requirements(apps)
        self.type = install_type
        self.no_backup = no_backup

    def _verify_app(self, app):
        if app['type'] == 'folder':
            return os.path.exists(Path(app[app['type']]).expanduser())
        else:
            if find_executable(app[app['type']]):
                return True
        return False

    def _verify_requirements(self, apps):
        self._logger.info('Checking for requirements')
        for app in apps:
            installed = self._verify_app(apps[app])
            apps[app]['installed'] = installed
            self._logger.debug('%s - installed: %s', app, installed)

        for app in apps:
            if not apps[app]['installed'] and apps[app]['required']:
                self._logger.fatal('\'%s\' is required but is not installed', app)
                return False
        return True
