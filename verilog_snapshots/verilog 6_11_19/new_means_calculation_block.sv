/*------------------------------------------------------------------------------
 * File          : new_means_calculation_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module new_means_calculation_block 
#(
	//div related MACROS
	tc_mode         = 0,
	rem_mode        =1,
	accum_width     = 7*22,
	count_width     = 10,
	//other MACROS
	addrWidth       = 8,
	dataWidth       = 91,
	centroid_num    =8,
	cordinate_width = 13,
	accum_cord_width = 22
) 
(
	//classification block InterFace
	input                    clk,
	input                    rst_n,
	input  [accum_width-1:0] accum_1,
	input  [accum_width-1:0] accum_2,
	input  [accum_width-1:0] accum_3,
	input  [accum_width-1:0] accum_4,
	input  [accum_width-1:0] accum_5,
	input  [accum_width-1:0] accum_6,
	input  [accum_width-1:0] accum_7,
	input  [accum_width-1:0] accum_8,
	//
	input  [count_width-1:0] cnt_1,
	input  [count_width-1:0] cnt_2,
	input  [count_width-1:0] cnt_3,
	input  [count_width-1:0] cnt_4,
	input  [count_width-1:0] cnt_5,
	input  [count_width-1:0] cnt_6,
	input  [count_width-1:0] cnt_7,
	input  [count_width-1:0] cnt_8,
	
	//controller interface
	input                    divider_en,
	input     [2:0]               cent_cnt,
	
	//convergence check block interface
	output [accum_width-1:0] quotient,
	output [accum_width-1:0] remainder,
	output                   divide_by_0
);

/*----Wires---*/
wire [accum_width-1:0]   a;
wire [count_width-1:0]   b;
reg  [accum_width-1:0] quot_reg;
//reg  



always @(rst_n==0 or posedge clk) begin
	if (rst_n==0) begin
		quotient <= 0;
		remainder <= 0;
		divide_by_0 <=0;
	end
	else begin
		quotient <= 0;
		remainder <= 0;
		divide_by_0 <=0;
	end
end


//mux for divisor and dividend
always_comb @(cent_cnt) begin
	case (cent_cnt)
		3'd0 : begin
			a = accum_1;
			b = cnt_1;
		end
		3'd1 : begin
			a = accum_2;
			b = cnt_2;
		end
		3'd2 : begin
			a = accum_3;
			b = cnt_3;
		end
		3'd3 : begin
			a = accum_4;
			b = cnt_4;
		end
		3'd4 : begin
			a = accum_5;
			b = cnt_5;
		end
		3'd5 : begin
			a = accum_6;
			b = cnt_6;
		end
		3'd6 : begin
			a = accum_7;
			b = cnt_7;
		end
		3'd7 : begin
			a = accum_8;
			b = cnt_8;
		end
	endcase
end



















endmodule : new_means_calculation_block