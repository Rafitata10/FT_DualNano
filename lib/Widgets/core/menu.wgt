# $Id: menu.wgt,v 1.13 2002/11/03 08:19:37 cgavin Exp $

##############################################################################
#
# Visual TCL - A cross-platform application development environment
#
# Copyright (C) 2001 Damon Courtney
#
# Description file for Tk Widget
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

# Menu edit code is located in menus.tcl

Class       Menu
Lib         core

Icon        icon_menu.gif
TreeLabel   @vTcl::widgets::core::menu::getWidgetTreeLabel
# DefaultOptions -background \$vTcl(actual_gui_menu_bg) -compound left
DefaultOptions -compound left -activeforeground black -activebackground #d9d9d9 \
            -background red
NewOption -menuspecial      "menu"          menuspecial
NewOption -tearoff          "tearoff"       boolean "0 1"
NewOption -postcommand      "post cmd"      command
NewOption -tearoffcommand   "tearoff cmd"   command
NewOption -title            "title"         type

DumpCmd       vTcl::widgets::core::menu::dumpCmd
DumpInfoCmd   vTcl::widgets::core::menu::dumpInfoCmd
DeleteCmd     vTcl::widgets::core::menu::deleteMenu
GetImagesCmd  vTcl::widgets::core::menu::getImagesCmd
GetFontsCmd   vTcl::widgets::core::menu::getFontsCmd

DoubleClickCmd  vTcl::widgets::core::menu::dblClkCmd

Function        "Edit Menu..."     vTcl::widgets::core::menu::editMenu

namespace eval vTcl::widgets::core::menu {

    proc editMenu {} {
        # Menu editing has code in three files. The menu editor itself
        # vTclWindow.vTclMenuEdit and most of the code is in
        # menus.tcl. The attribute stuff ::ui:attributes is located in
        # misc.tcl. The starting point seems to be in
        # vTcl:edit_target_menu located in lib_core.tcl.
        dblClkCmd $::vTcl(w,widget)
    }

    proc dblClkCmd {target} {
        global vTcl
        set class $vTcl(w,class)
        if {$class == "Menu"} {
            #if {[string first "pop" $target] > -1} {}
            #set base ".vTcl.menu_popup"
            #set menu  "new"  ;# NOT CORRECT
            set base $vTcl(w,insert)
            #vTclWindow.vTclMenuEdit $base $target  ;# In menus.tcl
            vTcl:edit_menu $target
        } else {
            set vTcl(w,opt,-menu) [$target cget -menu]
            vTcl:edit_target_menu $target
        }

        # this is necessary in order for the -menu option to be set right now
        update

        vTcl:prop:save_opt $target -menu vTcl(w,opt,-menu)
    }


    proc getWidgetTreeLabel {target} {
        global vTcl
        global widget
        # Special case - a real hack - for popup menus.  Rozen
        if {[string first "pop" $target] > -1} {
            return "Context Menu - $widget(rev,$target)"
            global widname
        }
        set components [split $target .]
        # let's see if the parent is a menu
        set size [llength $components]
        # parent is at least a toplevel
        if {$size <= 3} {
            return "Menubar"
        }
        set parent [lrange $components 0 [expr $size - 2] ]
        set parent [join $parent .]
        if { [vTcl:get_class $parent 1] != "menu" } {
        return "Menu"
        }
        for {set i 0} {$i <= [$parent index end]} {incr i} {
            if { [$parent type $i] != "cascade" } {
                continue
            }
            set menuwindow [$parent entrycget $i -menu]
            if {$menuwindow == $target} {
                return [$parent entrycget $i -label]
            }
        }
        return "Menubar"
    }

    proc deleteMenu {m} {
        # this will be used later
        set editor [::menu_edit::is_open_existing_editor $m]
        ::menu_edit::delete_menu_recurse $m
        # well, this is not enough to destroy the menu itself,
        # we better tell its parent that it's not there as well
        set items [split $m .]
        set items [lrange $items 0 [expr [llength $items] - 2] ]
        set parent [join $items .]
        # now, let's see if the parent contains the child menu (should)
        set class [vTcl:get_class $parent]
        if {$class == "Toplevel"} then {
                # it's a toplevel, just removes its menu
                $parent configure -menu ""
                # closes any open menu editor for this menu
                if {$editor != ""} {
                destroy $editor}
                return
        }
        if {$class != "Menu"} then return
        set last [$parent index end]
        for {set i 0} {$i <= $last} {incr i} {
                set mtype [$parent type $i]
                if {$mtype != "cascade"} then continue

                set submenu [$parent entrycget $i -menu]
                if {$submenu == $m} then {
                # this is the one
                $parent delete $i
                break
                }
        }
        # now, we will refresh any possibly open menu editor
        if {$editor != ""} {
                ::menu_edit::refreshes_existing_editor $editor
        }
    }

    proc getOption {target option} {
        set result {}
        set size [$target index end]
        if {[vTcl:streq $size "none"]} { return {} }
        for {set i 0} {$i <= $size} {incr i} {
        if {![catch {$target entrycget $i $option} value]} {
                lappend result $value
            }
        }
        return $result
    }

    proc getImagesCmd {target} {
        return [getOption $target -image]
    }

    proc getFontsCmd {target} {
        return [getOption $target -font]
    }

    proc dumpCmd {target basename} {
        global vTcl basenames
        ## discard temporary items
        if {[string first .# $target] >= 0} {
            return ""
        }
		set result ""
        ## first dump the menu widget
        set len [llength [split $target .]]

        append result [vTcl:dump_widget_opt $target $basename]

		## any entries in the menu?
        set entries [$target index end]
        if {$entries == "none"} {return $result}
        ## then all its submenus
        for {set index 0} {$index <= $entries} {incr index} {
            set conf [$target entryconf $index]
            set type [$target type $index]
            set len [llength [split $target .]]
			switch $type {
                tearoff {}
                cascade {
                    ## to allow option translation
                    set pairs [vTcl:get_subopts_special $conf $target]
					set sitevariable "site_[llength [split $target .]]_0"
                    append result "$vTcl(tab)\n"
                    # ---------------------------------------------------
                    if {$vTcl(copy) && $vTcl(copy_class) eq "Toplevel"} {		
						if {$len == 3} {
							# append result "set $sitevariable \$target\n"
							append result \
						 "$vTcl(tab)set $sitevariable [vTcl:base_name $target]\n"
							#append result "$vTcl(tab)$basename add $type \\\n"
						} else {
							# New stuff here. ##########################
							append result \
	                          "$vTcl(tab)set $sitevariable $vTcl(copy_name)\n"
                        }
						set vTcl(old_sitevariable) $sitevariable
							# set b \$\{top\}${menu}
                        set b $sitevariable
                        append result "$vTcl(tab)\$$b add $type \\\n"
					} elseif {$vTcl(copy) && $vTcl(copy_class) eq "Menu"} {
                        regsub {^\.top\d+|^\.bor\d+} $target "" menu
						set vTcl(copy_menu) $menu
                        # append result "set $sitevariable \$target\n"
						if {$len == 3} {
							append result \
						 "$vTcl(tab)set $sitevariable \$\{target\}\$\{menu\}\n"
						} else {
							append result \
	                          "$vTcl(tab)set $sitevariable $vTcl(copy_name)\n"
						}
						set vTcl(old_sitevariable) $sitevariable
                        set b $sitevariable
                        append result "$vTcl(tab)\$$b add $type \\\n"
                    } elseif {$vTcl(copy) && \
                                      $vTcl(copy_class) eq "Menubutton"} {
                        set ll  [$target entrycget $index -label]

                        # Most recent change Saturday.
                        #set sitevariable $sitevariable
                        regsub {^\.top\d+} $target "" menu
                        set vTcl(copy_menu) $menu
                        append result \
                           "$vTcl(tab)set $sitevariable \$\{target\}${menu}\n"
                        #append result \
                            "set $sitevariable  \$basename\n"
                        #append result \
                            "set $sitevariable  \$target\n"
                        #append result "$vTcl(tab)$sitevariable add $type \\\n"
                        append result "$vTcl(tab)$basename add $type \\\n"
                        append result \
                        "$vTcl(tab2)-menu \"\$site_4_0.m1\" -label $ll \n"
                    } elseif {$vTcl(copy) && $vTcl(copy_class) eq "Popupmenu"} {
						# New stuff added for popup menus starting 10/9/22.
						set m [vTcl:new_widget_name Menu ""]
						append result "$vTcl(tab)set $sitevariable \
                                   \${target}.$m\n"						
                    } else {
						append result \
                            "set $sitevariable [vTcl:base_name $target]\n"
                        append result "$vTcl(tab)$basename add $type \\\n"
                    }
                    # ---------------------------------------------------
					
					set copy_name \$$sitevariable.men[incr vTcl(menu_number)]
					set vTcl(copy_name) $copy_name
					#append result "$vTcl(tab)$basename add $type \\\n" moved up
                    #append result "$vTcl(tab)\$base add $type \\\n"
                    # append result "[vTcl:new_clean_pairs $pairs]\n"
                    append result "[vTcl:new_clean_pairs $pairs "" $copy_name]\n"

				
				    set basenames($target) \$$sitevariable
                    # ---------------------------------------------------
                    ## dump menu recursively
                    set childMenu [$target entrycget $index -menu]
				    set childBasename [vTcl:base_name $childMenu]
		if {$vTcl(copy)} {
			set childBasename $copy_name
		}

                    append result [dumpCmd $childMenu $childBasename]
                    catch {unset basenames($target)}
                }
			    default {
                    if {$len == 3 && $vTcl(copy) && \
                            $vTcl(copy_class) eq "Menu"} {
                        regsub {^\.top\d+|^\.bor\d+} $target "" menu
                        set vTcl(copy_menu) $menu
                        # set basename \${target}\${menu}
                        set basename \${top}\${menu}
                    }
                    set pairs [vTcl:get_subopts_special $conf $target]
                    append result "$vTcl(tab)$basename add $type \\\n"
                    append result "[vTcl:clean_pairs $pairs]\n"
                }
            }
        }
        return $result
    }

    proc dumpInfoCmd {target basename} {
        global vTcl basenames classes
		if {[string first .# $target] >= 0} {
            return ""
        }
        if {$vTcl(copy)} {
            return
        }
        ## first dump the menu widget info
        set result [vTcl:dump:widget_info $target $basename]
        ## any entries in the menu?
        set entries [$target index end]
        if {$entries == "none"} {return $result}
        ## then all its submenus
        for {set index 0} {$index <= $entries} {incr index} {
            set conf [$target entryconf $index]
            set type [$target type $index]
            switch $type {
                cascade {
                    set sitevariable "site_[llength [split $target .]]_0"
                    append result "$vTcl(tab)"
                    append result "set $sitevariable [vTcl:base_name $target]\n"
                    set basenames($target) \$$sitevariable
                    ## dump menu recursively
                    set childMenu [$target entrycget $index -menu]
                    set childBasename [vTcl:base_name $childMenu]
                    set childClass [vTcl:get_class $childMenu]
                    append result [$classes($childClass,dumpInfoCmd) \
                                       $childMenu $childBasename]
                    catch {unset basenames($target)}
                }
                default {
                }
            }
        }
        return $result
    }
}

# Bone pile

# 		if {$vTcl(copy)} {
# 			# copying from borrowee. So we first find an OK menu name.
# 			# set tree [vTcl:widget_tree $target]
# 			#set tree [vTcl:widget_tree .]
# 			foreach top $vTcl(tops) {
# 				set children [vTcl:widget_tree $top]
# dpr top
# dpl children
# 				foreach child $children {
# 					if {[string first "#" $child] > -1} continue
# 					set class [vTcl:get_class $child]
# dpr child class					
# 					if {$class eq "Menu"} {
# dmsg menu child $child
# 						set rr [regexp {\.men([0-9]+)$} $child ww number]
# 						set rr1 [regexp {\.m([0-9]+)$} $child ww number]
# dpr ww number						
# 						if {$rr || $rr1} {lappend ll $number}
# 					}
# 				}
# 			}
# dpr ll			
# 			#set ll [lsort -integer -unique $ll]
# 			set max [::tcl::mathfunc::max {*}$ll]
# dpl ll			
# dpl max
# 		}

    # First saved for reference.
#     proc dumpCmd {target basename} {
#         global vTcl basenames
#         ## discard temporary items
#         if {[string first .# $target] >= 0} {
#             return ""
#         }
#         ## first dump the menu widget
#         # Rozen. set changed to append so that I can output prior
#         # lines for copy menu. 1/14/18
#         #set result [vTcl:dump_widget_opt $target $basename]
#         # New Stuff 2/4
#         if {[llength [split $target .]] == 3}  {
#             set sitevariable "site_[llength [split $target .]]_0"
#             append result "$vTcl(tab)set $sitevariable $basename\n"
#             set basename \$$sitevariable
#         }
#         # End New Stuff
#         # Next line actually puts out the menu command.
#         append result [vTcl:dump_widget_opt $target $basename]
#         ## any entries in the menu?
#         set entries [$target index end]
#         if {$entries == "none"} {return $result}
#         ## then all its submenus
#         for {set index 0} {$index <= $entries} {incr index} {
#             set conf [$target entryconf $index]
#             set type [$target type $index]
#             switch $type {
#                 tearoff {}
#                 cascade {
#                     ## to allow option translation
#                     set pairs [vTcl:get_subopts_special $conf $target]
#                     set first_pairs [vTcl:get_subopts_special $conf $target]
#                     set new_list [list]
#                     # New
#                     set sub_menu_name [$target entrycget $index "-menu"]
#                     regsub $target $sub_menu_name $sitevariable sub_menu_site
#                     set site $sub_menu_site
#                     append result [vTcl:dump_widget_opt \
#                                        $sub_menu_name \$$sub_menu_site]
#                     foreach {option value} $first_pairs {
#                         # We go thru the option looking for "-menu".
#                         if {$option == "-menu"} {
#                             set value \$$sub_menu_site
#                             # Does it contain "$site", if substitute.
#                     #         set ss [string first "\$site" $value]
# #                             if {$ss == -1} {
# #                                 # Lets do the correction. Take both
# #                                 # the target and the value apart and
# #                                 # then reconstruct the value with
# #                                 # $site_.. and appropriate pieces
# #                                 # from the target and the value.
# #                                 set split_target [split $target "."]
# #                                 if {[set ll [llength $split_target]] > 3} {
# #                                     set split_target [lrange $split_target 3 end]
# #                                 } else {
# #                                     set split_target [list]
# #                                 }
# #                                 set value [string trim $value "\""]
# #                                 set split_value [split $value "."]
# #                                 set split_value [lrange $split_value 2 end]
# #                                 if {$ll > 3} {
# #                                     lappend new_list \\$basename $split_target \
# #                                     $split_value
# #             dpr list
###    foreach {i val} $list {
###dpr i val		
###                    } else {
# #                                     lappend new_list $basename $split_value
# #                                 }
# #                                 set new [join $new_list "."]
# #                                 set new \"$new\"
# #                             } else {
# #                                  set new $value
# #                             }
# # dpr new target
# # dpr value
# #                             set vv [split $value "."]
# #                             set ts [split $target "."]
# #                             set tr [lrange $ts 0 1]
# #                             set range [lrange $vv 1 end]
# #                             set v5 [join [list {*}$tr {*}[lrange $vv 1 end]] "."]
# #                             append result [dumpCmd $v5 $new] ;# new 5/24/20
# # dmsg after dumping menu: result = $result
# #                             lappend new_pairs $option $new
#                             # end if -menu
#                         } else {
#                             #lappend new_pairs $option $value
#                         }
#                         lappend new_pairs $option $value
#                     }
#                     set pairs $new_pairs
#                     append result "$vTcl(tab)$basename add $type \\\n"
#                     # append result "[vTcl:clean_pairs $pairs]\n" Template change
#                     append result "[vTcl:clean_pairs $pairs Menu]\n"
#                     # if {[llength [split $target .]] != 3}  {
#                     # set sitevariable "site_[llength [split $target .]]_0"

#                     # append result "$vTcl(tab)"
#                     # append result "set $sitevariable [vTcl:base_name $target]\n"
#                     # }
#                     set basenames($target) \$$sitevariable
#                     ## dump menu recursively
#                     set childMenu [$target entrycget $index -menu]
#                     set childBasename [vTcl:base_name $childMenu]
#                     lappend recurse_list [list $childMenu $childBasename]
#                     #append result [dumpCmd $childMenu $childBasename]
#                     catch {unset basenames($target)}
#                 }
#                 default {
#                     # to allow option translation
#                     set pairs [vTcl:get_subopts_special $conf $target]
#                     append result "$vTcl(tab)$basename add $type \\\n"
#                     # append result "[vTcl:clean_pairs $pairs]\n" Template change
#                     append result "[vTcl:clean_pairs $pairs Menu]\n"
#                 }
#             }
#         }
#         # NEEDS WORK I think we can delete the if group
#         if {$vTcl(copy)} {
#             set pieces [split $target "."]
#             set last_piece [lrange $pieces end end]
#             #append result "$vTcl(tab)\$top configure -menu \$top.m38\n"
#             append result "$vTcl(tab)\$top configure -menu \$top.$last_piece\n"
#             #append result  "$vTcl(tab)\puts \[\$top configure\]\n "
#         }
#         return $result
#     }
