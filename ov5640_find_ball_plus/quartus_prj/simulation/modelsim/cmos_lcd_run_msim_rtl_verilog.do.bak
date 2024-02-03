transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {e:/app/quartus ii 13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {e:/app/quartus ii 13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {e:/app/quartus ii 13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {e:/app/quartus ii 13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {e:/app/quartus ii 13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {e:/app/quartus ii 13.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/key.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/wrfifo.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_para.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_fifo_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_controller.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/rdfifo.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd/lcd_rgb_top.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/cmos_lcd.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd/lcd_driver.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd/rd_id.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/lcd/clk_div.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/uart {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/uart/uart_tx.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/uart {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/uart/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/uart {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/uart/rs232.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640 {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640/i2c_dri.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640 {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640/ov5640_cfg.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640 {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640/ov5640_data.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640 {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/ov5640/picture_size.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_top.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/ipcore {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/ipcore/pll.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/servo_dri.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/image_top.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/ycbcr_disp.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/erode_disp.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/binarization.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/dialate_disp.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/matrix_3x3_16bit.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/ipcore {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/ipcore/shift_ip.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/image/coordinate.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid/error.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid/pid_value.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid/incre_value.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/pid/pid_top.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/db {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_data.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/rtl/sdram/sdram_cmd.v}

vlog -vlog01compat -work work +incdir+D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/../sim {D:/WorkSpace/FPGA_Projects/ov5640_find_ball_plus/quartus_prj/../sim/tb_uart_rx.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_uart_rx

add wave *
view structure
view signals
run 10 ms
