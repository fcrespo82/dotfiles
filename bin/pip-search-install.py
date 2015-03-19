#!/usr/bin/env python
# encoding: utf-8
"""
Usage:
    pip-search-install.py PACKAGE_NAME
"""

from __future__ import unicode_literals
from __future__ import print_function
from docopt import docopt
import subprocess
import re
import getpass
import sys
sys.dont_write_bytecode = True
import os
sys.path.append(os.path.realpath(os.path.join(os.path.dirname(sys.argv[0]), "../lib")))
from color import white, cyan, magenta, blue, yellow, green, red

VERSION = "0.1"

def search(package):
    found = subprocess.check_output(["pip", "search", package])
    options = []
    for line in found.splitlines():
        m = re.match(r"(?P<name>.*?) - (?P<desc>.*)", line)
        if (m):
            name = m.group("name")
            desc = m.group("desc")
        options.append({"name": name, "desc": desc})
    return options

def install(package_name):
    print(blue("Installing {0}".format(package_name)))
    response = subprocess.call(["pip", "install", package_name])

def update(package_name):
    print(blue("Upgrading {0}".format(package_name)))
    response = subprocess.call(["pip", "install", "-U", package_name])

def choose(options, su):
    for i, option in enumerate(options):
        print("{0:>3}: {1} - {2}".format(i + 1, green(option["name"].decode('utf-8')), option["desc"].decode('utf-8')))

    if su:
        choosen = raw_input("Qual o pacote que deseja instalar (numero ou vazio)? ")
        if choosen:
            return int(choosen) - 1  #print("Will install {0}".format(choosen))

def check_sudo():
    if getpass.getuser() != "root":
        print(red("You should run this as root to install/update, this time you only be able to search."))
        return False
    else:
        return True

def main():
    args = docopt(__doc__, version=VERSION)
    su = check_sudo()
    op = search(args["PACKAGE_NAME"])
    choosen = choose(op, su)
    if su:
        response = raw_input("Instalar ou atualizar [i/a]? ")
        install_or_update = True if response == "i" else False
        if install_or_update:
            install(op[choosen]["name"])
        else:
            update(op[choosen]["name"])


main()
