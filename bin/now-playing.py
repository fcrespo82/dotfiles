#!/usr/bin/env python3
#coding: utf-8

from __future__ import unicode_literals
from __future__ import print_function
import requests
import datetime

response = requests.get("http://ajax.last.fm/user/fxfc/now")
data = response.json()

music = data["track"]["name"]
artist = data["track"]["artist"]["name"]

utc_time = data["utc"]

listened = datetime.datetime.fromtimestamp(utc_time)

since = datetime.datetime.now()-listened

minutes = 2

if since.seconds <= 60 * minutes:
    print("{0} - {1}".format(artist, music))
