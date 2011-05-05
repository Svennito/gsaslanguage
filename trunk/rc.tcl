# first argument: name of CIF file
set file [lindex $argv 0]
# second argument: name of .EXP file to create
set expgui(expfile) [lindex $argv 1]
# third argument: location of EXPGUI directory
set expguiloc [lindex $argv 2]
# fourth argument: location of GSAS directory
set expgui(gsasdir) [lindex $argv 3]

# load in EXPGUI files
source ${expguiloc}/gsascmds.tcl
source ${expguiloc}/readexp.tcl
source ${expguiloc}/addcmds.tcl
source ${expguiloc}/import_cif.tcl
source ${expguiloc}/browsecif.tcl
# set location of exe's
set expgui(gsasexe) [file join $expgui(gsasdir) exe]
# misc vars
set expgui(changed) 1
set expgui(archive) 1
set expgui(Revision) ""
set expgui(MacAssignApp) 0
set expgui(debug) 0

# a window will be required
package require Tk
# replace needed expgui routines
proc InitLSvars {} {}
proc loadexp {expfile} {
    global expgui expmap entryvar entrycmd tcl_platform
    #set expfile [SetEXPfile $expfile]
    if {$expfile == ""} {
	return
    }
    # read in the .EXP file
    set fmt [expload $expfile]
    set expgui(expfile) $expfile
    set expgui(changed) 0
    mapexp 
}

# get to work 
createexp $expgui(expfile) "from $file"
mapexp
set expgui(changed) 1
# read in the CIF
set cifout [ReadCIFFile $file]
# assign variables
foreach {spg cell atoms dummy} $cifout {}
foreach {a b c alpha beta gamma} $cell {}
set title "from $file"
# add the phase
set errmsg [runAddPhase $title $spg $a $b $c $alpha $beta $gamma]
# reformat the atoms
set atomlist {}
foreach atom $atoms {
    lappend atomlist "[lindex $atom 4] [lrange $atom 1 3]  [lindex $atom 5] \
		  [lindex $atom 0] I [lindex $atom 6]"
}
# add them
runAddAtoms 1 $atomlist
exit
