transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/app/intelfpga/17.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/app/intelfpga/17.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/app/intelfpga/17.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/app/intelfpga/17.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/app/intelfpga/17.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {d:/app/intelfpga/17.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S6.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S5.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S4.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S3.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S2.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S1.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_op_S0.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_lite.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_ip.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_dec_M4.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_dec_M3.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_dec_M2.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_dec_M1.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_dec_M0.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S6.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S5.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S4.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S3.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S2.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S1.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_arb_S0.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip/rom {D:/soc_m3/1_rtl/ip/rom/ahb_rom.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip {D:/soc_m3/1_rtl/ip/ahb_sram.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip {D:/soc_m3/1_rtl/ip/apb_reg.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip {D:/soc_m3/1_rtl/ip/apb_uart.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip {D:/soc_m3/1_rtl/ip/ahb_default_slave.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/cortex_m3 {D:/soc_m3/1_rtl/cortex_m3/cortexm3ds_logic.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/apb {D:/soc_m3/1_rtl/bus/apb/apb_top.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/apb {D:/soc_m3/1_rtl/bus/apb/apb_slave_mux.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/apb {D:/soc_m3/1_rtl/bus/apb/ahb_to_apb.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl {D:/soc_m3/1_rtl/soc_m3_top.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip/rom {D:/soc_m3/1_rtl/ip/rom/my_rom.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip/iobuf {D:/soc_m3/1_rtl/ip/iobuf/IOBUF.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/ip/pll {D:/soc_m3/1_rtl/ip/pll/pll.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/3_syn/db {D:/soc_m3/3_syn/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7 {D:/soc_m3/1_rtl/bus/ahb/mybusmatrix5x7/mybusmatrix5x7_default_slave.v}

vlog -vlog01compat -work work +incdir+D:/soc_m3/3_syn/../2_sim {D:/soc_m3/3_syn/../2_sim/tb_soc_m3.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_soc_m3

add wave *
view structure
view signals
run -all
