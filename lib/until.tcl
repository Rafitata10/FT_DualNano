
# Done by Reinhard Max
# at the Texas Tcl Shoot-Out 2000
# in Austin, Texas,
# with subsequent updates

proc do {script arg2 {arg3 {}}} {
    # Implements a "do <script> until <expression>" loop
    # The "until" keyword ist optional
    # 
    # It is as fast as builtin "while" command for loops with
    # more than just a few iterations.

    if {$arg3 eq {}} {
        # copy the expression to arg3 if only
        # two arguments are supplied
        set arg3 $arg2
    } else {
        if {$arg2 ne {until}}
            return -code 1 {Error: do script ?until? expression}
        }
    }

    set ret [catch {uplevel $script} result copts] 
    switch $ret {
        0 -
        4 {}
        3 return
        default {
            return -options [dict replace $copts -level 2] $result
        }
    }
    
    set ret [catch {uplevel [list while !($arg3) $script]} result copts]
    return -options $copts $result
}
