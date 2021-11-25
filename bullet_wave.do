setenv LMC_TIMEUNIT -9
vlib work
vmap work work
vcom -2008 -work work "bullet.vhd"

vcom -2008 -work work "bullet_tb.vhd"
vsim +notimingchecks -L work work.bullet_tb -wlf testbench.wlf

add wave -noupdate -group bullet_tb
add wave -noupdate -group bullet_tb -radix hexadecimal /bullet_tb/*

add wave -noupdate -group bullet
add wave -noupdate -group bullet -radix decimal /bullet_tb/dut/*

add wave -noupdate -group collision_h
add wave -noupdate -group collision_h -radix decimal /bullet_tb/dut/collision_h_case/*

add wave -noupdate -group collision_l
add wave -noupdate -group collision_l -radix decimal /bullet_tb/dut/collision_l_case/*

run -all