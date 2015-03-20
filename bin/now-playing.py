#!/usr/bin/env python3
#coding: utf-8

from __future__ import unicode_literals
from __future__ import print_function
import requests

response = requests.get("http://ajax.last.fm/user/fxfc/now")
data = response.json()

music = data["track"]["name"]
artist = data["track"]["artist"]["name"]

# print(artist)
# print(music)
print("{0} - {1}".format(artist, music))
