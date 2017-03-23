import logging

class Installation(object):
    def __init__(self, config):
        self._log = logging.getLogger(__name__)
        self.config = config

    def perform(self):
        self._log.info('Perform')
        self._log.debug(self.config.type)
        if self.config.type == 'install':
            self.install()
        elif self.config.type == 'remove':
            self.uninstall()

    def install(self):
        self._log.info("Install")
        if not self.config.no_backup:
            self._backup()

    def uninstall(self):
        self._log.info("Uninstall")

    def _backup(self):
        self._log.info("Backing up")
