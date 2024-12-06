vlib work

vlog -lint -source top_module.sv 
vlog -lint -source functional_unit.sv 
vlog -lint -source i2c_interface.sv 
vlog -lint -source maintb.sv 
vlog -lint -source memory.sv 
vlog -lint -source memory_controller.sv

vsim -voptargs=+acc work.testbench_tb

add wave sim:/testbench_tb/DUT/*

run -all
