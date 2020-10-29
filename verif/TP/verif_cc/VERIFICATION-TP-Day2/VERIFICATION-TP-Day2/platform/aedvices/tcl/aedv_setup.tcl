
global DEBUG 
global PUTS
global ARCH

set DEBUG 1


if { $ARCH == "linux" && $SIMULATOR == "questasim" } {
    set PUTS echo
} else {
    set PUTS puts
}

proc aed_cmd { cmd } {
	global DEBUG
	global PUTS
	if { $DEBUG == 1 } {
		$PUTS $cmd
	}
  catch {  
    eval $cmd
  } err
}

