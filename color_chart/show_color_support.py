#! /usr/bin/env python3
#  -*- coding: utf-8 -*-
#
# Support module generated by PAGE version 8.0K
#  in conjunction with Tcl version 8.6
#    Nov 21, 2023 06:02:41 PM PST  platform: Linux

import sys
import tkinter as tk
import tkinter.ttk as ttk
from tkinter.constants import *

import show_color
import re
import math

_debug = True # False to eliminate debug printing from callback functions.

def main(*args):
    '''Main entry point for the application.'''
    global root
    root = tk.Tk()
    root.protocol( 'WM_DELETE_WINDOW' , root.destroy)
    # Creates a toplevel widget.
    global _top1, _w1
    _top1 = root
    _w1 = show_color.Toplevel1(_top1)
    run()
    root.mainloop()

def run():
    args = sys.argv[1:]
    args = ' '.join(args)
    if args == '':
        print("Please restart as: show_color.py <color> where <color> is an X11 color name or the digits of an X11 color.")
        sys.exit()
    color_name = ''
    ret = re.search("^[0-9a-f]{6}$", args)
    if re.search("^[0-9a-f]{6}$", args):
        color = "#" + args
        hex = 1
    elif re.search("^#[0-9a-f]{6}$", args):
        color = args
        hex = 1
    else:
        color = args
        color_name = args
        hex = 0

    _w1.Label1.configure(text=color_name)
    _w1.Frame1.configure(background=color)
    rgb = _top1.winfo_rgb(color)
    rgb = tuple((c//256 for c in root.winfo_rgb(color)))
    (r, g, b) = rgb
    

    _w1.Message2.configure(text=color)
    if hex == 0:
       msg = "#%02x%02x%02x" % (rgb[0], rgb[1], rgb[2])
       _w1.Message2.configure(text=msg)
    h = math.sqrt(0.299 * (r * r) + 0.587 * (g * g)+ 0.114 * (b * b))
    if h > 127.5:
        l_or_d = 'Light'
    else:
        l_or_d = 'Dark'

    _w1.Message3.configure(text=l_or_d)


    hsv = rgb_to_hsv(rgb)
    rgb_complement = complement(hsv)
    
    _w1.Label1_1.configure(text='')
    _w1.Message2_1.configure(text=rgb_complement)
    _w1.Frame1_1.configure(background=rgb_complement)
    rgb = _top1.winfo_rgb(rgb_complement)
    rgb = tuple((c//256 for c in root.winfo_rgb(rgb_complement)))
    (r, g, b) = rgb
    h = math.sqrt(0.299 * (r * r) + 0.587 * (g * g)+ 0.114 * (b * b))
    if h > 127.5: l_or_d = 'Light'
    else: l_or_d = 'Dark'
    _w1.Message3_1.configure(text=l_or_d)    

import colorsys

def complement(hsv):
    h, s, v = hsv
    hue_complement = (h + 180) % 360
    rgb_complement = hsv_to_rgb(hue_complement/360, s/100, v/100)
    return rgb_complement

def rgb_to_hsv(rgb_tuple):
    # Extract RGB values
    r, g, b = rgb_tuple
    # Normalize RGB values to be between 0 and 1
    
    r = r / 255
    g = g / 255
    b = b / 255
    
    # Convert RGB to HSV
    h, s, v = colorsys.rgb_to_hsv(r, g, b)

    # Convert Hue from degrees to the range 0 to 1
    h = h * 360

    # Convert Saturation and Value to the range 0 to 1
    s = s * 100
    v = v * 100
    # Return HSV values as a tuple
    return h, s, v


    
def hsv_to_rgb(h, s, v):
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    r = int(r * 255)
    g = int(g * 255)
    b = int(b * 255)
    rgb_hex = "#{:02x}{:02x}{:02x}".format(r, g, b)
    return rgb_hex  
    
if __name__ == '__main__':
    show_color.start_up()



