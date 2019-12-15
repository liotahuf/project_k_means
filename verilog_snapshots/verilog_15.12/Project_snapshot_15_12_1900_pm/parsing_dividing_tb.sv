/*------------------------------------------------------------------------------
 * File          : parsing_dividing_tb.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module parsing_dividing_tb #(
	tc_mode          = 1,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10
) ();
/*------------ Wires adn Regs------------*/


reg clk;
reg rst_n;
reg  [accum_width-1:0] accum;
reg  [count_width-1:0] cnt;

wire [accum_cord_width-1:0 ] result_cord_1;
wire [accum_cord_width-1:0 ] result_cord_2;
wire [accum_cord_width-1:0 ] result_cord_3;
wire [accum_cord_width-1:0 ] result_cord_4;
wire [accum_cord_width-1:0 ] result_cord_5;
wire [accum_cord_width-1:0 ] result_cord_6;
wire [accum_cord_width-1:0 ] result_cord_7;

/*----------Instantiation------------*/
parsing_dividing parsing_dividing (
	.accumulator  (accum        ),
	.counter      (cnt          ),
	//
	.result_cord_1(result_cord_1),
	.result_cord_2(result_cord_2),
	.result_cord_3(result_cord_3),
	.result_cord_4(result_cord_4),
	.result_cord_5(result_cord_5),
	.result_cord_6(result_cord_6),
	.result_cord_7(result_cord_7)
);

integer_to_fixed_point_and_concatenating integer_to_fixed_point_and_concatenating (
	.result_cord_1(result_cord_1),
	.result_cord_2(result_cord_2),
	.result_cord_3(result_cord_3),
	.result_cord_4(result_cord_4),
	.result_cord_5(result_cord_5),
	.result_cord_6(result_cord_6),
	.result_cord_7(result_cord_7),
	.new_centroid(new_centroid)
);

//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;



task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		cnt = 0;
		accum =0;
		
		
		
		
		#2.5 rst_n = 1'b1;
	end
endtask

task set_inputs;
	input [accum_width-1 :0] dividend;
	input [accum_width-1 :0] divisor;
	begin
		accum = dividend;
		cnt = divisor;
	end
	
endtask

//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	initiate_all;
	#10
	set_inputs({132'b0,9'b0,4'b0111,9'b0},10'd2);
	#10
	set_inputs({132'b0,9'b0,4'b0011,9'b0},10'd3);
	#10
	set_inputs({132'b0,11'b0,11'b11010011101},10'd13);//result is 0.1270 = {14'b0,10000010}
	#10
	set_inputs({88'b0,22'b1111111111110001110101,22'b0,22'b1111111111101000001000},10'd11);//result is 1111 1111 1111 1111 0101 110
	#10
	$finish;
end

endmodule : parsing_dividing_tb