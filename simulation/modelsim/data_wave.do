onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /wave_drawer_datapath_testbench/dut/clk
add wave -noupdate /wave_drawer_datapath_testbench/dut/reset
add wave -noupdate /wave_drawer_datapath_testbench/start
add wave -noupdate /wave_drawer_datapath_testbench/dut/init
add wave -noupdate /wave_drawer_datapath_testbench/dut/draw
add wave -noupdate /wave_drawer_datapath_testbench/dut/idle
add wave -noupdate /wave_drawer_datapath_testbench/dut/erase
add wave -noupdate /wave_drawer_datapath_testbench/dut/signal
add wave -noupdate /wave_drawer_datapath_testbench/dut/done
add wave -noupdate /wave_drawer_datapath_testbench/dut/invalidate
add wave -noupdate /wave_drawer_datapath_testbench/dut/pen
add wave -noupdate -radix unsigned /wave_drawer_datapath_testbench/dut/x
add wave -noupdate -radix unsigned /wave_drawer_datapath_testbench/dut/y
add wave -noupdate /wave_drawer_datapath_testbench/dut/i
add wave -noupdate -radix unsigned /wave_drawer_datapath_testbench/dut/idx
add wave -noupdate -radix unsigned /wave_drawer_datapath_testbench/dut/count
add wave -noupdate /wave_drawer_datapath_testbench/dut/buffer
add wave -noupdate /wave_drawer_datapath_testbench/dut/y_buffer
add wave -noupdate /wave_drawer_datapath_testbench/dut/y_divided
add wave -noupdate /wave_drawer_datapath_testbench/dut/first_condition
add wave -noupdate /wave_drawer_datapath_testbench/dut/second_condition
add wave -noupdate /wave_drawer_datapath_testbench/dut/third_condition
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58 ps} 0}
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
WaveRestoreZoom {0 ps} {1468 ps}
