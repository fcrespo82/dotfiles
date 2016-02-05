#! /usr/bin/env python3
# encoding: utf-8

import requests

USERNAME="fcrespo82"

class GitHub:
    def __init__(self, user):
        self.username=user
        self.__PUBLIC_REPOS_URL="https://api.github.com/users/{username}/repos".format(username=user)
        self.__public_load_repos()

    def __public_load_repos(self):
        response=requests.get(self.__PUBLIC_REPOS_URL)
        self.__PUBLIC_REPOS=response.json()
        self.public_repos_names = ""
        for repo in self.__PUBLIC_REPOS:
            #self.public_repos_names="{0}\n{1}".format(self.public_repos_names, repo['git_url'])
            self.public_repos_names="{0}\n{1}".format(self.public_repos_names, repo['ssh_url'])
            #self.public_repos_names="{0}\n{1}".format(self.public_repos_names, repo['clone_url'])
            #self.public_repos_names="{0}\n{1}".format(self.public_repos_names, repo['svn_url'])


gh=GitHub(USERNAME)

print(gh.public_repos_names.strip())
