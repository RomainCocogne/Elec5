onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PADDR
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PCLK
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PENABLE
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PRDATA
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PREADY
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PRESETn
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PSEL
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PSLVERR
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PWDATA
add wave -noupdate -expand -group {VIP M} /lab04/apb_m/PWRITE
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_paddr
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_penable
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_prdata
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_pready
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_psel
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_pslverr
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_pwdata
add wave -noupdate -expand -group {DUT M} /lab04/dut0/m_pwrite
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_paddr
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_penable
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_prdata
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_pready
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_psel
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_pslverr
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_pwdata
add wave -noupdate -expand -group {DUT S} /lab04/dut0/s_pwrite
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PADDR
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PCLK
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PENABLE
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PRDATA
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PREADY
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PRESETn
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PSEL
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PSLVERR
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PWDATA
add wave -noupdate -expand -group {VIP S} /lab04/apb_s/PWRITE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2312640 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {24870660 ps}
