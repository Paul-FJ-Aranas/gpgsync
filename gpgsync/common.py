# -*- coding: utf-8 -*-
"""
GPG Sync
Helps users have up-to-date public keys for everyone in their organization
https://github.com/firstlookmedia/gpgsync
Copyright (C) 2016 First Look Media

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""
import os, sys, re, platform, inspect
from PyQt5 import QtCore, QtWidgets, QtGui

def alert(msg, details='', icon=QtWidgets.QMessageBox.Warning):
    d = QtWidgets.QMessageBox()
    d.setWindowTitle('GPG Sync')
    d.setText(msg)

    if details:
        d.setDetailedText(details)

    d.setIcon(icon)
    d.exec_()

def valid_fp(fp):
    return re.match(b'^[A-F\d]{40}$', clean_fp(fp))

def clean_fp(fp):
    return fp.strip().replace(b' ', b'').upper()

def fp_to_keyid(fp):
    return '0x{}'.format(clean_fp(fp)[-16:].decode()).encode()

def clean_keyserver(keyserver):
    if b'://' not in keyserver:
        return b'hkp://' + keyserver
    return keyserver

def get_resource_path(filename):
    if platform.system() == 'Linux':
        prefix = os.path.join(sys.prefix, 'share/gpgsync')
    elif platform.system() == 'Darwin':
        # Check if app is running inside an app bundle
        if 'GPGSYNC_RESOURCE_DIR' in os.environ:
            prefix = os.environ['GPGSYNC_RESOURCE_DIR']
        else:
            prefix = os.path.join(os.path.dirname(sys.executable), 'share')

    resource_path = os.path.join(prefix, filename)
    return resource_path

icon = None
def get_icon():
    global icon
    if not icon:
        icon = QtGui.QIcon(get_resource_path('gpgsync.png'))
    return icon

syncing_icon = None
def get_syncing_icon():
    global syncing_icon
    if not syncing_icon:
        syncing_icon = QtGui.QIcon(get_resource_path('syncing.png'))
    return syncing_icon

error_icon = None
def get_error_icon():
    global error_icon
    if not error_icon:
        error_icon = QtGui.QIcon(get_resource_path('error.png'))
    return error_icon
