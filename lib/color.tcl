##############################################################################
# $Id: color.tcl,v 1.8 2001/11/30 04:22:49 cgavin Exp $
#
# color.tcl - color browser
#
# Copyright (C) 1996-1998 Stewart Allen
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

##############################################################################

proc vTcl:get_color {color w {t {Choose a color}}} {
    # Rozen.  Changed this routine to use the colorDlg color picker
    # written by Alain (he gives no last name.) Mainly I added the
    # third parameter and changed the call below to colorDlg.

    # apparently Iwidgets 3.0 returns screwed up colors
    #
    # tk_chooseColor accepts the following:
    # #RGB           (4 chars)
    # #RRGGBB        (7 chars)
    # #RRRGGGBBB     (10 chars)
    # #RRRRGGGGBBBB  (13 chars)
    if {[string first "#" $color] > -1} {
        if {[string length $color] == 11} {
            set extend [string range $color 10 10]
            set color $color$extend$extend
            vTcl:log "Fixed color: $color"
        } else {
            if {[string length $color] == 9} {
                set extend [string range $color 8 8]
                set color $color$extend$extend$extend$extend
                vTcl:log "Fixed color: $color"
            }
        }
    }
    global vTcl tk_version tcl_platform
    set oldcolor $color
    if {$color == "" || $color == "#000000"} {
        set color white
    }
    # I tried several color choosers; the list is follows. I decided
    # to use this form of a color chooser, where I can enter X11 color
    # names.

    #set newcolor \
     [SelectColor::menu [winfo toplevel $w].color [list below $w] -color $color]
    # colorDlg is the one I have been using most recently.
    #set newcolor [::colorDlg::colorDlg -initialcolor $color -title $t]
    # set newcolor [tk_chooseColor -initialcolor $color -title $t]
    #set newcolor [tk_chooseColor  -title $t]
    #set newcolor [colorDlg -initialcolor $color -title $t]

    # On the recommended version of Tcl for Windows, colorDlg
    # doesn't work, so I fall back to tk_chooseColor.
    if {$tcl_platform(platform) == "windows" } {
        # set newcolor [tk_chooseColor -initialcolor $color -title $t]
        set newcolor [tk_chooseColor -title $t]
    } else {
        # Everywhere else.
        set newcolor [::colorDlg::colorDlg -initialcolor $color -title $t]
        #set newcolor [::colorDlg::colorDlg -title $t]
    }
    if {$newcolor != ""} {
        return $newcolor
    } else {
        return $oldcolor
    }
}

proc vTcl:show_color {widget option variable w} {
    # This may only be used in propmgr.tcl to get the right color for
    # the ellipses in the Attribute Editor.
    global vTcl
    set vTcl(color,widget)   $widget
    set vTcl(color,option)   $option
    set vTcl(color,variable) $variable
    set color [vTcl:at $variable]
    # The if-elseif block of code blow is no longer needed for the
    # color chooser being used.
    # if {$color == ""} {
    #     set color "#000000"
    # } elseif {[string range $color 0 0] != "#" } {
    #     set clist [winfo rgb . $color]
    #     set r [lindex $clist 0]
    #     set g [lindex $clist 1]
    #     set b [lindex $clist 2]
    #     set color "#[vTcl:hex $r][vTcl:hex $g][vTcl:hex $b]"
    # }
    set vTcl(color) [vTcl:get_color $color $w]
    if {[::colorDlg::dark_color $vTcl(color)]} {
        set ell_image ellipseslight
    } else {
        set ell_image ellipsesdark
    }
    set $vTcl(color,variable) $vTcl(color)
    $vTcl(color,widget) configure -bg $vTcl(color) -image $ell_image
    $vTcl(w,widget) configure $vTcl(color,option) $vTcl(color)
}

proc vTcl:set_actuals { } {
    # These setting are done after the preferences (.pagerc) are read
    # which might change the following preference variable. Called in
    # page.tcl. These may be overwritten when a project file (a .tcl
    # file) is opened. Called from vTcl:setup in page.tcl.
    global vTcl
    set vTcl(actual_bg) $vTcl(pr,bgcolor)                   ;# 11/6/18
    set vTcl(actual_fg) $vTcl(pr,fgcolor)                   ;# 11/6/18
    set vTcl(actual_gui_bg) $vTcl(pr,guibgcolor)
    set vTcl(actual_gui_fg) $vTcl(pr,guifgcolor)
    set vTcl(actual_gui_analog) $vTcl(pr,guianalogcolor)    ;# 11/6/18
    set vTcl(actual_gui_menu_bg) $vTcl(pr,menubgcolor)
    set vTcl(actual_gui_menu_fg) $vTcl(pr,menufgcolor)
    set vTcl(actual_gui_menu_analog) $vTcl(pr,menuanalogcolor)  ;# 11/6/18
    set vTcl(complement_color) $vTcl(pr,guicomplement_color)
    set vTcl(analog_color_p) $vTcl(pr,guianalog_color_p)
    set vTcl(analog_color_m) $vTcl(pr,guianalog_color_m)
    set vTcl(actual_bg_analog) $vTcl(pr,bganalogcolor)        ;# 11/6/18
    #set vTcl(actual_treehighlight) $vTcl(pr,treehighlight)
    set ac [::colorDlg::analogous_colors $vTcl(actual_bg)]
    set vTcl(analog_color_p) [lindex $ac 0]
    set vTcl(analog_color_m) [lindex $ac 1]
	set ttk_bg [ttk::style lookup . -background]
	set vTcl(actual_bg) $ttk_bg
	set vTcl(complement_color) [::colorDlg::complement $vTcl(actual_bg)]
	# set vTcl(complement_color) [complement $vTcl(actual_bg)]
    # The tabfg1 and tabfg2 colors are the foreground colors of
    # unselected tabs of notebook widgets. I toyed with making those
    # colors variations of the preferred GUI foreground color but ran
    # into too many problems. I have decided to use beige. that then
    # allows me to set both tabfg1 and tabfg2 to black since beige is
    # light.

    if {$vTcl(actual_gui_bg) eq "f5f5dc" || $vTcl(actual_gui_bg) eq "beige"} {
        set vTcl(analog_color_m) pink
    } else {
        set vTcl(analog_color_m) beige
    }
    
    set vTcl(tabfg1) "black" ;# background when mouse is over tab
	if {[::colorDlg::dark_color $vTcl(complement_color)]} {	
		set vTcl(tabfg2) "white"
	} else {
		set vTcl(tabfg2) "black"
	}
    set vTcl(tabbg1) #d9d9d9 ;# background when mouse is over tab
	set vTcl(tabbg2) $vTcl(complement_color) ;# complement of the
											  # background color from
											  # preferences.

	# Removed the following 4/28/22 because I think it is a mistake to
    # use any color for the foreground other than the preferred color!!!
    # I do the following because I end up using complentary colors of
    # gui bacground for the active background color and so if that
    # color is dark then I set the active foreground color white;
    # otherwise black.                 ;# NEEDS WORK dark
    # if {[::colorDlg::dark_color $vTcl(analog_color_m)]} {
    #     set fg_color  white       ;# Dealing with a dark background.
    # } else {
    #     set fg_color  black       ;# Dealing with a light background.
    # }

    if {[::colorDlg::dark_color $vTcl(actual_bg)]} {
        set vTcl(bg_mode) dark
    } else {
        set vTcl(bg_mode) light
    }
    # vTcl(analog_color_m) is the activeforground color. Note above
    # that I've taken the coward's way out and ALWAYS use beige. Thus,
    # one should not use beige as the primary color.
    if {[::colorDlg::dark_color $vTcl(analog_color_m)]} {
        set vTcl(fg_mode) dark
    } else {

		set vTcl(fg_mode) light
    }
    if {$vTcl(fg_mode) eq "light"} {
        set vTcl(active_fg) black
    } else {
        set vTcl(active_fg) white
    }

    #set vTcl(active_fg) $vTcl(actual_fg)
    set vTcl(actual_gui_font_dft) $vTcl(font,gui_font_dft)
    set vTcl(actual_gui_font_fixed) $vTcl(font,gui_font_fixed)
    set vTcl(actual_gui_font_text) $vTcl(font,gui_font_text)
    set vTcl(actual_gui_font_menu) $vTcl(font,gui_font_menu)

    set vTcl(actual_gui_menu_active_bg) $vTcl(actual_gui_menu_analog)
    if {[::colorDlg::dark_color $vTcl(actual_gui_menu_analog)]} {
        set menu_fg_color  #111111
    } else {
        set menu_fg_color  #000000
    }
    set vTcl(actual_gui_menu_active_fg) $menu_fg_color
    set vTcl(actual_autoalias) $vTcl(pr,autoalias)
    set vTcl(actual_relative_placement) $vTcl(pr,relative_placement)
}

proc vTcl:set_GUI_color_defaults { fileID } {
    # Rozen. This writes out code to set default upon loading the
    # generated GUI tcl file.
    global vTcl
    puts $fileID "########################################### "
    puts $fileID "set vTcl(actual_gui_bg) $vTcl(actual_gui_bg)"
    puts $fileID "set vTcl(actual_gui_fg) $vTcl(actual_gui_fg)"
    puts $fileID "set vTcl(actual_gui_analog) $vTcl(pr,guianalogcolor)"
    puts $fileID "set vTcl(actual_gui_menu_analog) $vTcl(pr,menuanalogcolor)"
    puts $fileID "set vTcl(actual_gui_menu_bg) $vTcl(actual_gui_menu_bg)"
    puts $fileID "set vTcl(actual_gui_menu_fg) $vTcl(actual_gui_menu_fg)"

    puts $fileID "set vTcl(complement_color) $vTcl(complement_color)"
    puts $fileID "set vTcl(analog_color_p) $vTcl(analog_color_p)"
    puts $fileID "set vTcl(analog_color_m) $vTcl(analog_color_m)"
    puts $fileID "set vTcl(tabfg1) $vTcl(tabfg1)"
    puts $fileID "set vTcl(tabfg2) $vTcl(tabfg2)"
    puts $fileID "set vTcl(actual_gui_menu_active_bg) \
                   $vTcl(actual_gui_menu_active_bg)"
    puts $fileID "set vTcl(actual_gui_menu_active_fg) \
                   $vTcl(actual_gui_menu_active_fg)"
    puts $fileID "########################################### "
}

# A set of routines found at:
# https://code.activestate.com/recipes/133529-color-manipulation/

# rgb2dec --
#
#   Turns #rgb into 3 elem list of decimal vals.
#
# Arguments:
#   c		The #rgb hex of the color to translate
# Results:
#   Returns a #RRGGBB or #RRRRGGGGBBBB color
#
proc rgb2dec c {
    set c [string tolower $c]
    if {[regexp -nocase {^#([0-9a-f])([0-9a-f])([0-9a-f])$} $c x r g b]} {
	# double'ing the value make #9fc == #99ffcc
	scan "$r$r $g$g $b$b" "%x %x %x" r g b
    } else {
	if {![regexp {^#([0-9a-f]+)$} $c junk hex] || \
		[set len [string length $hex]]>12 || $len%3 != 0} {
	    if {[catch {winfo rgb . $c} rgb]} {
		return -code error "bad color value \"$c\""
	    } else {
		return $rgb
	    }
	}
	set len [expr {$len/3}]
    	scan $hex "%${len}x%${len}x%${len}x" r g b
    }
    return [list $r $g $b]
}

# dec2rgb --
#
#   Takes a color name or dec triplet and returns a #RRGGBB color.
#   If any of the incoming values are greater than 255,
#   then 16 bit value are assumed, and #RRRRGGGGBBBB is
#   returned, unless $clip is set.
#
# Arguments:
#   r		red dec value, or list of {r g b} dec value or color name
#   g		green dec value, or the clip value, if $r is a list
#   b		blue dec value
#   clip	Whether to force clipping to 2 char hex
# Results:
#   Returns a #RRGGBB or #RRRRGGGGBBBB color
#
proc dec2rgb {r {g 0} {b UNSET} {clip 0}} {
    if {![string compare $b "UNSET"]} {
	set clip $g
	if {[regexp {^-?(0-9)+$} $r]} {
	    foreach {r g b} $r {break}
	} else {
	    foreach {r g b} [winfo rgb . $r] {break}
	}
    } 
    set max 255
    set len 2
    if {($r > 255) || ($g > 255) || ($b > 255)} {
	if {$clip} {
	    set r [expr {$r>>8}]; set g [expr {$g>>8}]; set b [expr {$b>>8}]
	} else {
	    set max 65535
	    set len 4
	}
    }
    return [format "#%.${len}X%.${len}X%.${len}X" \
	    [expr {($r>$max)?$max:(($r<0)?0:$r)}] \
	    [expr {($g>$max)?$max:(($g<0)?0:$g)}] \
	    [expr {($b>$max)?$max:(($b<0)?0:$b)}]]
}

# shade --
#
#   Returns a shade between two colors
#
# Arguments:
#   orig	start #rgb color
#   dest	#rgb color to shade towards
#   frac	fraction (0.0-1.0) to move $orig towards $dest
# Results:
#   Returns a shade between two colors based on the
# 
proc shade {orig dest frac} {
    if {$frac >= 1.0} { return $dest } elseif {$frac <= 0.0} { return $orig }
    foreach {origR origG origB} [rgb2dec $orig] \
	    {destR destG destB} [rgb2dec $dest] {
	set shade [format "\#%02x%02x%02x" \
		[expr {int($origR+double($destR-$origR)*$frac)}] \
		[expr {int($origG+double($destG-$origG)*$frac)}] \
		[expr {int($origB+double($destB-$origB)*$frac)}]]
	return $shade
    }
}

# complement --
#
#   Returns a complementary color
#   Does some magic to avoid bad complements of grays
#
# Arguments:
#   orig	start #rgb color
# Results:
#   Returns a complement of a color
# 
proc complement {orig {grays 1}} {
    foreach {r g b} [rgb2dec $orig] {break}
    set R [expr {(~$r)%256}]
    set G [expr {(~$g)%256}]
    set B [expr {(~$b)%256}]
    if {$grays && abs($R-$r) < 32 && abs($G-$g) < 32 && abs($B-$b) < 32} {
	set R [expr {($r+128)%256}]
	set G [expr {($g+128)%256}]
	set B [expr {($b+128)%256}]
    }
    return [format "\#%02x%02x%02x" $R $G $B]
}
