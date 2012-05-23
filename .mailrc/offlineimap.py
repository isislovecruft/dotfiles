#!/usr/bin/env python
# -*- coding: utf-8 -*-
########################################################################
# $HOME/.offlineimap.py
#
# Python helper file for OfflineIMAP
#
# @author Isis Agora Lovecruft, 0x2cdb8b35
# @version 0.0.1
#
#-----------------------------------------------------------------------
# Changelog:
########################################################################

import os

def parse_credentials(filename, hostname):
    """
    Parses filename for IMAP user credentials for a remote server.

    Example file ('$HOME/.offlineimap.myserver'):
        myserver mail.myserver.net username password

    This file should be chmod'd to 0600.
    """

    mailrc = os.path.expanduser('~/.mailrc')
    filepath = os.path.join(mailrc, filename)

    with open(filepath) as fh:
        lines = fh.readlines()
        for line in lines:
            if line.startswith(hostname):
                separated = line.split(' ')
                remote_host = separated[1]
                user = separated[2]
                passwd = separated[3]
                return remote_host, user, passwd

def get_remote_hostname(filename, hostname):
    """
    Returns just remote_host from the above function.
    """
    rhn, u, pw = parse_credentials(filename, hostname)
    return rhn

def get_username(filename, hostname):
    """
    Returns just username from the above function.
    """
    rhn, u, pw = parse_credentials(filename, hostname)
    return u

def get_password(filename, hostname):
    """
    Returns just password from the above function.
    """
    rhn, u, pw = parse_credentials(filename, hostname)
    return pw

