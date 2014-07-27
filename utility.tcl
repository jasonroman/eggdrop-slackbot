# see http://wiki.tcl.tk/1018

proc listns {{parentns ::}} {
    set result [list]
    foreach ns [namespace children $parentns] {
        lappend result {*}[listns $ns] $ns
    }
    return $result
}

proc listnsvars {{ns ::}} {
    return [info vars ${ns}::*]
}