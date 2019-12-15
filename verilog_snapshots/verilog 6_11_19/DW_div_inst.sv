/*------------------------------------------------------------------------------
 * File          : DW_div_inst.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module DW_div_inst #(accum_width = 7*22, a_width = 91, b_width = accum_width, tc_mode = 0, rem_mode=1) 
(
	input [a_width-1 : 0] a,
	input [b_width-1 : 0] b,
	output [a_width-1 : 0] quotient,
	output [a_width-1 : 0] remainder,
	output divide_by_0
);

//parameter rem_mode = 1; // corresponds to "%" in Verilog


// Please add +incdir+$SYNOPSYS/dw/sim_ver+ to your verilog simulator
// command line (for simulation).
// instance of DW_div
DW_div #(a_width,b_width, tc_mode, rem_mode)
U1 (.a(a), .b(b),
.quotient(quotient), .remainder(remainder),
.divide_by_0(divide_by_0));
endmodule





endmodule : DW_div_inst