#!/usr/bin/env python
# -*- coding: utf-8 -*-
#####################################################################
#
# ascii_art_maker.py
#
# Makes ascii art out of an image on the internet and prints it to
# stdout.
#
# @author Isis Lovecruft, 0x2cdb8b35
# @version 1.0.0
#
# Taken from http://jwilk.net/software/python-aalib
#####################################################################

import aalib
import Image
import urllib2
from sys import argv
from cStringIO import StringIO

def asciify(image_url):
    """
    Takes an image from the interwebs and turns it into ascii art.

    FTFW like wut.
    """
    screen = aalib.AsciiScreen(width=80, height=40)
    fp = StringIO(urllib2.urlopen(image_url).read())
    image = Image.open(fp).convert('L').resize(screen.virtual_size)
    screen.put_image((0, 0), image)
    print screen.render()

if __name__ == "__main__":
    asciify(argv[1])
