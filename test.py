import unittest
import re


class TestRegexMethods(unittest.TestCase):

    def setUp(self):
        self.pattern = r'^(?P<command>\w+|\W+(?=\s))(?: is an | is a | is | )?(?P<type>shell function from|alias for|not found|reserved word|shell builtin)?\s?(?P<path>/.*|.*)$'
        self.lines = [
            'zplug is a shell function from /Users/fernando/.zplug/autoload/zplug',
            'zsh is /bin/zsh',
            'g is an alias for git',
            'git is /usr/bin/git',
            'asdf is /Users/fernando/.asdf/bin/asdf',
            'zasdf not found',
            '{ is a reserved word',
            '. is a shell builtin'
        ]
        self.matches = [
            {
                'input': 'zplug is a shell function from /Users/fernando/.zplug/autoload/zplug',
                'command': 'zplug',
                'type': 'shell function from',
                'path': '/Users/fernando/.zplug/autoload/zplug'
            }, {
                'input': 'zsh is /bin/zsh',
                'command': 'zsh',
                'type': None,
                'path': '/bin/zsh'
            }, {
                'input': 'g is an alias for git',
                'command': 'g',
                'type': 'alias for',
                'path': 'git'
            }
        ]

    def test_all_lines_matches(self):
        for line in self.lines:
            self.assertRegex(line, self.pattern)

    def test_all_commands(self):
        for item in self.matches:
            match = re.match(self.pattern, item['input'])
            self.assertEqual(match.group('command'), item['command'])

    def test_all_types(self):
        for item in self.matches:
            match = re.match(self.pattern, item['input'])
            self.assertEqual(match.group('type'), item['type'])

    def test_all_paths(self):
        for item in self.matches:
            match = re.match(self.pattern, item['input'])
            self.assertEqual(match.group('path'), item['path'])

    def path(self, actual, expected):
        self.assertEqual(actual, expected)

if __name__ == '__main__':
    unittest.main()
