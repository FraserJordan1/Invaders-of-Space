onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /seg7_display_status_testbench/CLOCK_50
add wave -noupdate /seg7_display_status_testbench/player_lives
add wave -noupdate /seg7_display_status_testbench/enemy_count
add wave -noupdate /seg7_display_status_testbench/HEX5
add wave -noupdate /seg7_display_status_testbench/HEX4
add wave -noupdate /seg7_display_status_testbench/HEX3
add wave -noupdate /seg7_display_status_testbench/HEX2
add wave -noupdate /seg7_display_status_testbench/HEX1
add wave -noupdate /seg7_display_status_testbench/HEX0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000 ps} 0}
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
configure wave -gridperiod 300
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1008 ps}
