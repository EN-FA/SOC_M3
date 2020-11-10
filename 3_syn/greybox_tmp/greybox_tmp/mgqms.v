//altiobuf_bidir CBX_SINGLE_OUTPUT_FILE="ON" enable_bus_hold="FALSE" INTENDED_DEVICE_FAMILY=""Cyclone IV E"" number_of_channels=0 open_drain_output="FALSE" use_differential_mode="FALSE" use_dynamic_termination_control="FALSE" use_termination_control="FALSE" WIDTH_PTC=14 WIDTH_STC=14 datain dataio dataout oe
//VERSION_BEGIN 17.1 cbx_mgl 2017:10:25:18:08:29:SJ cbx_stratixii 2017:10:25:18:06:53:SJ cbx_util_mgl 2017:10:25:18:06:53:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2017  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details.



//synthesis_resources = altiobuf_bidir 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgqms
	( 
	datain,
	dataio,
	dataout,
	oe) /* synthesis synthesis_clearbox=1 */;
	input   datain;
	inout   dataio;
	output   dataout;
	input   oe;

	wire  wire_mgl_prim1_dataout;

	altiobuf_bidir   mgl_prim1
	( 
	.datain(datain),
	.dataio(dataio),
	.dataout(wire_mgl_prim1_dataout),
	.oe(oe));
	defparam
		mgl_prim1.enable_bus_hold = "FALSE",
		mgl_prim1.intended_device_family = ""Cyclone IV E"",
		mgl_prim1.number_of_channels = 0,
		mgl_prim1.open_drain_output = "FALSE",
		mgl_prim1.use_differential_mode = "FALSE",
		mgl_prim1.use_dynamic_termination_control = "FALSE",
		mgl_prim1.use_termination_control = "FALSE",
		mgl_prim1.width_ptc = 14,
		mgl_prim1.width_stc = 14;
	assign
		dataout = wire_mgl_prim1_dataout;
endmodule //mgqms
//VALID FILE
