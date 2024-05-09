##############################################################################
#
# theme.tcl - Suppport for Themes starting with Version 8.0
#
# Copyright (C) 2023 Donald Rozenberg
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

# See vTcl:create_widget for the setting of background style.

proc vTcl:setup_theme {} {
    # re we invoke the desired theme.
	global vTcl
    set themes [ttk::style theme names]
	ttk::style theme use $vTcl(current_theme)
    set used_theme [ttk::style theme use]
	ttk::style configure . -font \"$vTcl(actual_gui_font_dft_desc)\"
    if {$vTcl(current_theme) eq "page"} { return }
    if {$vTcl(current_theme) eq "page-legacy"} {
		#vTcl:initial_options
		return
	}
return	
    if {$vTcl(current_theme) in  {sun-valley-dark sun-valley-light}} {
		## To activate sun-valley theme. The file design and the way
		## this this theme is invoked is apparently different from that of
		## other themes. So it must be treated differently here.
		set savedir [pwd]
		cd themes/Sun-Valley-ttk-theme-master
		source sun-valley.tcl
		set themes [ttk::style theme names]
		cd $savedir
		if {$vTcl(current_theme) eq "sun-valley-dark"} {
			set_theme dark   ;# Located in themes/sun-valley.tcl
		} else {
			set_theme light
		}
	}
	#ttk::style configure TLabelframe.Label \
		-background $vTcl(actual_gui_bg)
}

proc vTcl:initial_options { } {
	global vTcl
    #option clear
	set bg [ttk::style lookup . -background]
        set fg [ttk::style lookup . -foreground]
        # option add *vTcl*background $vTcl(pr,bgcolor)
        option add *vTcl*background $bg
        option add *vTcl*foreground $fg
        set vTcl(actual_bg) [ttk::style lookup . -background]
        set vTcl(actual_fg) [ttk::style lookup . -foreground]
        set vTcl(dark) [::colorDlg::dark_color $bg]
        set fff [ttk::style lookup . -font]
        option add *vTcl*font $fff
        set sbg [ttk::style lookup . -selectbackground]
        set abg [ttk::style lookup . -activebackground]
        option add *vTcl*activebackground cyan
        #set layout [ttk::style layout TCheckbutton]
    ttk::style configure TLabelframe.Label -background $vTcl(actual_gui_bg)
    ttk::style configure TLabelframe.Label -foreground $vTcl(actual_gui_fg)
    ttk::style configure TLabelframe.Label \
	    -font "$vTcl(actual_gui_font_dft_desc)"    
}

proc vTcl:change_theme { } {
	# Check all widgets in GUI and if a wdget is a tk widget then
	# reconfigure background and foregound.
	global vTcl

	# tk_setPalette \
		    #   background [ttk::style lookup . -background] \
		   	#   foreground [ttk::style lookup . -foreground] \
		   	# 		highlightColor [ttk::style lookup . -focuscolor] \
			# 		selectBackground [ttk::style lookup . -selectbackground] \
			# 		selectForeground [ttk::style lookup . -selectforeground] \
			# 		activeForground black \
			# 		activeBackground #d9d9d9

	vTcl:destroy_handles
	set theme [ttk::style theme use]
	#vTcl:reset_actual_colors
	#incr vTcl(change)
	set vTcl(current_theme) $theme
	if {$theme eq "page-legacy"} {
		# Read the default theme to get the right colors.
		# set theme_dir $vTcl(VTCL_HOME)
		# set filename [file join $theme_dir themes page-legacy.tcl ]
		# catch {source $filename}
		# ttk::style theme use page-legacy
		ttk::style configure . \
	        -background $vTcl(actual_gui_bg) \
			-foreground $vTcl(actual_gui_fg) \
			-font $vTcl(actual_gui_font_dft_desc)
			# -font $vTcl(pr,font_dft)
		#set vTcl(current_theme) page-legacy
        tk_setPalette \
			foreground "$vTcl(actual_gui_fg)" \
		    background "$vTcl(actual_gui_bg)" \
			activeForeground black \
			activeBackground #d9d9d9 \
			selectForeground black  \
			selectBackground  #d9d9d9 


		option add *Dialog*foreground black
		#set op [option get *Dialog foreground]
		#vTcl:set_actual
		vTcl:reset_legacy_tab_colors
		return
	}
	#ttk::style theme use $vTcl(current_theme)
	# ttk::style configure . -font  $vTcl(pr,font_dft)
	ttk::style configure . -font  $vTcl(actual_gui_font_dft_desc)
    set bgcolor [ttk::style lookup . -background]
	set fgcolor [ttk::style lookup . -foreground]
	
	set selbg [ttk::style lookup . -selectbackground]
	set selfg [ttk::style lookup . -selectforeground]
	tk_setPalette \
		background $bgcolor \
	    foreground $fgcolor \
	    activeForeground black \
		activeBackground #d9d9d9 \
		selectForeground black  \
		selectBackground  #d9d9d9
	update
	set comp [complement $vTcl(actual_gui_bg)]
	
	
}

proc vTcl:reconfigure_widget {widget} {
	# Recursive function to reconfigure widget and all sub widgets.
}

proc vTcl:reset_actual_colors {} {
	# set the fg and bg for the new theme.
	global vTcl
    set vTcl(actual_gui_fg) [ttk::style lookup . -foreground]
    set vTcl(actual_gui_bg) [ttk::style lookup . -background]	
}

proc vTcl:reset_legacy_tab_colors {} {
	global vTcl
	#set comp [complement $vTcl(actual_gui_bg)]
	set comp  [::colorDlg::complement $vTcl(actual_gui_bg)]
    set vTcl(tabfg1) "black" ;# background when mouse is over tab
    #set vTcl(tabfg1) $comp ;# background when mouse is over tab
    if {[::colorDlg::dark_color $comp]} {	
		set vTcl(tabfg2) "white"
	} else {
		set vTcl(tabfg2) "black"
	}
    set vTcl(tabbg1) #d9d9d9 ;# background when mouse is over tab
	set vTcl(tabbg2) $comp ;# complement of the background color

	
    ttk::style map TNotebook.Tab -background \
		[list selected $vTcl(actual_gui_bg) \
			 active $vTcl(tabbg1) !active $vTcl(tabbg2)]


	ttk::style map TNotebook.Tab -foreground \
		[list selected $vTcl(actual_gui_fg) \
			 active $vTcl(tabfg1) !active $vTcl(tabfg2)]
	
}			  

