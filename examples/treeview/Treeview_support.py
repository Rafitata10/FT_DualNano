#! /usr/bin/env python3
#  -*- coding: utf-8 -*-
#
# Support module generated by PAGE version 7.6rc3
#  in conjunction with Tcl version 8.6
#    Nov 29, 2022 03:06:45 AM CST  platform: Linux
#    Nov 29, 2022 03:16:52 AM CST  platform: Linux
#    Nov 29, 2022 03:25:48 AM CST  platform: Linux
# ===================================================
# Borrowed from PAGE 6.2 examples
# Reimagined and reworked by G.D. Walters for PAGE 7.6+
#     creation date:    11/29/2022
#
# ===================================================
"""
This is a rework of Guilherme Polo's example to include
folder icons which open and close.  Polo's example is Based
on bitwalk's directory browser
<http://bitwalk.blogspot.com/2008/01/ttktreeview.html>..
"""
# ===================================================
import sys
import os
import os.path

import tkinter as tk
import tkinter.ttk as ttk
from tkinter.constants import *

import Treeview

_debug = True  # False to eliminate debug printing from callback functions.
location = Treeview._location


def main(*args):
    '''Main entry point for the application.'''
    global root
    root = tk.Tk()
    root.protocol('WM_DELETE_WINDOW', root.destroy)
    # Creates a toplevel widget.
    global _top1, _w1
    _top1 = root
    _w1 = Treeview.Main(_top1)
    startup()
    root.mainloop()


def startup():
    # Set background of toplevel window to match current style
    style = ttk.Style()
    theme = style.theme_use()
    default = style.lookup(theme, 'background')

    global folder, openfold, stop
    global treeview
    folder = tk.PhotoImage(
        file=os.path.join(location, 'images/icons/folder.gif'))
    openfold = tk.PhotoImage(
        file=os.path.join(location, 'images/icons/openfold.gif'))
    stop = tk.PhotoImage(file=os.path.join(location, 'images/icons/stop.gif'))

    treeview = _w1.Scrolledtreeview1
    treeview.bind('<<TreeviewSelect>>', lambda e: update_tree(treeview))
    treeview.bind('<<TreeviewOpen>>', lambda e: tree_open(treeview))
    treeview.bind('<<TreeviewClose>>', lambda e: tree_close(treeview))
    treeview.bind('<Button-1>', lambda e: on_TV_Click(e))
    init_tree(treeview)
    # Open the first item
    treeview.item('I001', open=True)


def init_tree(tree):
    global folder, openfold, stop
    tree.column('#0')
    # tree.columns = ("File System", "Path")
    tree.heading('#0', text='File System')
    tree.heading("Col1", text="Path")
    node = tree.insert('',
                       'end',
                       text='/',
                       image=folder,
                       values=['/', 'directory'])
    populate_tree(tree, node)


def populate_tree(tree, node):
    global folder, openfold, stop
    nd = tree.item(node)
    n_type = nd['values'][1]
    if (n_type != 'directory'): return
    n_path = nd['values'][0]
    children = tree.get_children(node)
    try:
        tree.delete(children)
    except:
        pass
    flist = os.listdir(n_path)
    flist.sort()
    for f in flist:
        path = os.path.join(n_path, f)
        if (os.path.isdir(os.path.join(n_path, f))):
            id = tree.insert(node,
                             'end',
                             text=f,
                             image=folder,
                             values=(path, 'directory'))
            tree.insert(id, 'end', text='dummy')
        else:
            id = tree.insert(node, 'end', text=f, values=(path, 'file'))
    tree.item(node, values=(n_path, 'processed'))


def update_tree(tree):
    sel = tree.selection()
    populate_tree(tree, sel)


def tree_open(tree):
    global folder, openfold, stop
    sel = tree.selection()
    print(f'Tree_Open: sel={sel}')
    tree.item(sel, image=openfold)


def tree_close(tree):
    global folder, openfold, stop
    sel = tree.selection()
    print(f'Tree_Close: sel={sel}')
    tree.item(sel, image=folder)


def on_TV_Click(*args):
    if _debug:
        print('Treeview_support.on_TV_Click')
        for arg in args:
            print('    another arg:', arg)
        sys.stdout.flush()
        global treeview
        row = treeview.identify_row(args[0].y)
        col = treeview.identify_column(args[0].x)
        print(f'Row: {row}  Col: {col}')


def on_btnExit(*args):
    if _debug:
        print('Treeview_support.on_btnExit')
        for arg in args:
            print('    another arg:', arg)
        sys.stdout.flush()
    sys.exit()


if __name__ == '__main__':
    Treeview.start_up()
