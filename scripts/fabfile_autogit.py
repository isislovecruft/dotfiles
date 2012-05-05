#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Autopull remotes for git repositories in current directory.
# Example directory layout:
# /home/<user>/dev/
#               |_ fabfile.py
#               |_ project/
#               |       |_ .git/
#               |_ anotherproject/
#                       |_ .git/
#
# Usage: $ fab git
#
# If you have specific instructions for certain repos, i.e. if
# you would like a certain repo to pull from someone else's remote
# ('git pull <person> <branch>') see the function git_pull_remotes()
# for ways to configure.
#
# Author::Isis Lovecruft
# Copyright::GPLv3
#
# Postscriptum: This scriptum is better if you have toilet and steam
# locomotive. :)

from fabric.api import *
import fnmatch
import os
import fabric.contrib.project as project

HERE = os.path.abspath(os.path.dirname(__file__))
CWD  = os.getcwd()

env.hosts = ['localhost']
env.passwords = {}

def find(where, filepattern):
    """
    Find file in the current $PATH which matches a find style pattern.
    """
    for path, dirlist, filelist in os.walk(where):
        for match in fnmatch.filter(filelist, filepattern):
            yield os.path.join(path, match)

def whereis(where, dirpattern):
    """
    Find directory in the current $PATH which matches a find style pattern.
    """
    for path, dirlist, filelist in os.walk(where):
        for match in fnmatch.filter(dirlist, dirpattern):
            yield os.path.join(path, match)

def subdirs(parent, dirpattern=None):
    """
    Yeah, I call myself. Recursion, biatch. Like standing in between two
    mirrors.
    """
    for listing in os.listdir(parent):
        child = os.path.abspath(listing)
        if os.path.isdir(child):
            if not dirpattern:
                yield child
            else:
                matches = (subdir for subdir in whereis(child, dirpattern))
                for match in matches:
                    if not match:
                        subdirs(child, dirpattern)
                    else:
                        yield match

def git_pull_remotes():
    """
    Queer as folk!
    """
    for subdir in subdirs(HERE, '.git'):

        gitdir = subdir.rsplit('/', 1)[0]
        with lcd(gitdir):

            local('echo %s | toilet --gay' % os.path.basename(gitdir))
            local('git checkout master')

        ## REPOS WITH PERSONAL FORKS
        ## usually you'll want to do 'git pull <someone> <theirbranch>'

            if gitdir.endswith('project_i_contribute_to'):
                local('git pull other_person their_branch')
            elif gitdir.endswith('another_project_i_contribute_to'):
                local('git pull other_person their_branch')
            
        ## EXCLUDES
        ## Don't touch these repos
            
            elif (gitdir.endswith('my_project') 
                  or gitdir.endswith('my_other_project')):
                local('sl')

        ## CLONES
        ## Update these the normal way
            
            else:
                local('git pull origin')

def git():
    execute(git_pull_remotes)
