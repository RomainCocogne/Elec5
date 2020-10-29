
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
    global EXEC_CMD

    set EXEC ""
    if { [info exists EXEC_CMD] } {
        if { [info exists ::env(LAB_LAUNCHER)] } {
            set EXEC "${EXEC_CMD} $::env(LAB_LAUNCHER)"
            regsub -all {\[} $EXEC \\\[ EXEC
            regsub -all {\]} $EXEC \\\] EXEC
        } else {
            set EXEC "${EXEC_CMD} "
        }
    } 



    if { $DEBUG == 1 } {
        $PUTS "${EXEC} $cmd"
    }

    # FIXME. The catch finds an error while running on ST bsub, but the command runs.
    if { [catch {
        $PUTS [eval ${EXEC} $cmd]
    } err] } {
        $PUTS "Something went wrong !!!"
        $PUTS "Error Message: $::errorInfo"
    }
    #catch {
    #    $PUTS [eval ${EXEC} $cmd]
    #} err
}

