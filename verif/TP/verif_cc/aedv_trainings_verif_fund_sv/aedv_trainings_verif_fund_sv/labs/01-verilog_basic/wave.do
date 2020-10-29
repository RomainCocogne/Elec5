onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB /adder_2nx2n_tb/result
add wave -noupdate -expand -group TB /adder_2nx2n_tb/cout
add wave -noupdate -expand -group TB /adder_2nx2n_tb/data1
add wave -noupdate -expand -group TB /adder_2nx2n_tb/set1
add wave -noupdate -expand -group TB /adder_2nx2n_tb/data2
add wave -noupdate -expand -group TB /adder_2nx2n_tb/set2
add wave -noupdate -expand -group TB /adder_2nx2n_tb/get
add wave -noupdate -expand -group TB /adder_2nx2n_tb/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1 ns} {9 ns}
