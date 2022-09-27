onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /wave_drawer_controller_testbench/clk
add wave -noupdate /wave_drawer_controller_testbench/reset
add wave -noupdate /wave_drawer_controller_testbench/start
add wave -noupdate /wave_drawer_controller_testbench/done
add wave -noupdate /wave_drawer_controller_testbench/invalidate
add wave -noupdate /wave_drawer_controller_testbench/init
add wave -noupdate /wave_drawer_controller_testbench/draw
add wave -noupdate /wave_drawer_controller_testbench/idle
add wave -noupdate /wave_drawer_controller_testbench/erase
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {338 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3224 ps}
