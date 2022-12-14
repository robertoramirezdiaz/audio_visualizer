onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /wave_drawer_testbench/dut/clk
add wave -noupdate /wave_drawer_testbench/dut/reset
add wave -noupdate /wave_drawer_testbench/dut/start
add wave -noupdate /wave_drawer_testbench/dut/enable
add wave -noupdate /wave_drawer_testbench/dut/wave_signal
add wave -noupdate /wave_drawer_testbench/dut/pen
add wave -noupdate -radix unsigned /wave_drawer_testbench/dut/x
add wave -noupdate -radix unsigned /wave_drawer_testbench/dut/y
add wave -noupdate /wave_drawer_testbench/dut/done
add wave -noupdate /wave_drawer_testbench/dut/invalidate
add wave -noupdate /wave_drawer_testbench/dut/init
add wave -noupdate /wave_drawer_testbench/dut/draw
add wave -noupdate /wave_drawer_testbench/dut/idle
add wave -noupdate /wave_drawer_testbench/dut/erase
add wave -noupdate /wave_drawer_testbench/dut/signal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1397 ps} 0}
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
WaveRestoreZoom {0 ps} {4 ns}
