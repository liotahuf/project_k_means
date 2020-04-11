/*------------------------------------------------------------------------------
 * File          : DW_div_inst.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module DW_div_inst #( a_width = 22, b_width = 22, tc_mode = 1, rem_mode=1) 
(
	input [a_width-1 : 0] a,
	input [b_width-1 : 0] b,
	output [a_width-1 : 0] quotient,
	output [a_width-1 : 0] remainder,
	output divide_by_0
);

//parameter rem_mode = 1; // corresponds to "%" in Verilog

reg clk;
reg rst_n;
reg  [a_width-1:0] dividend;
reg  [b_width-1:0] divisor;


// Please add +incdir+$SYNOPSYS/dw/sim_ver+ to your verilog simulator
// command line (for simulation).
// instance of DW_div
DW_div #(a_width,b_width, tc_mode, rem_mode)
U1 (.a(dividend), .b(divisor),
.quotient(quotient), .remainder(remainder),
.divide_by_0(divide_by_0));



//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;



task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		dividend = 0;
		divisor =0;
		
		
		
		
		#2.5 rst_n = 1'b1;
	end
endtask

task set_inputs;
	input [a_width-1 :0] dividend_in;
	input [b_width-1 :0] divisor_in;
	begin
		dividend = dividend_in;
		divisor = divisor_in;
	end
	
endtask

//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	initiate_all;
	#10
	set_inputs(22'd7,10'd3);
	#10
	set_inputs(22'b1111111111101000001000,10'd19);//result is 111 111 111 111 111 011 0000
	#10

	$finish;
end






endmodule : DW_div_inst