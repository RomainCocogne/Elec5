#Intermediate script
global LAB_FILE
global LAB_TYPE

if { $argc <2 } {
    puts "Number of arguments is insufficient."
}

set LAB_FILE [lindex $argv 0]
set LAB_TYPE [lindex $argv 1]

source env.tcl
source run_test.tcl

compile_and_load