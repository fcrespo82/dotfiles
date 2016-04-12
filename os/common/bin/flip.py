#!/usr/bin/env python
#coding: utf8

from sys import stdin, stdout

pchars = u"abcdefghijklmnopqrstuvwxyz,.?!'()[]{}"
fchars = u"ɐqɔpǝɟƃɥıɾʞlɯuodbɹsʇnʌʍxʎz'˙¿¡,)(][}{"
flipper = dict(zip(map(ord, pchars), fchars))
a = list(stdin.read().decode('utf8').lower().translate(flipper))[:-1]
a.reverse()
stdout.write(''.join(a).encode('utf8'))
