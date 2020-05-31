/*------------------------------------------------------------------------------
 * File          : new_means_calculation_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module new_means_calculation_block #(
	parameter
	//div related MACROS
	tc_mode          = 0,
	rem_mode         =1,
	accum_width      = 7*22,
	count_width      = 10,
	//other MACROS
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	cordinate_width  = 13,
	accum_cord_width = 22
) (
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
	input  [2:0]             cent_cnt,
	
	//convergence check block interface
	output [2:0]			 cent_cnt_nxt_block,
	output                   divide_by_0,
	output [dataWidth-1:0]   new_centroid
);

/*----Wires---*/
reg [accum_width-1:0]   curr_accum;
reg [count_width-1:0]   curr_cnt;
reg  [dataWidth-1:0] output_reg;
reg divided_by_0_reg;
reg [2:0] cent_cnt_nxt_block_reg;
/*------instances interfaces wires------*/
wire [accum_cord_width-1:0 ] result_cord_1;
wire [accum_cord_width-1:0 ] result_cord_2;
wire [accum_cord_width-1:0 ] result_cord_3;
wire [accum_cord_width-1:0 ] result_cord_4;
wire [accum_cord_width-1:0 ] result_cord_5;
wire [accum_cord_width-1:0 ] result_cord_6;
wire [accum_cord_width-1:0 ] result_cord_7;
wire [dataWidth-1:0] new_centroid_wire;
wire divide_by_0_wire;


/*----------Instantiation------------*/
parsing_dividing parsing_dividing (
	.accumulator  (curr_accum   ),
	.counter      (curr_cnt     ),
	//
	.result_cord_1(result_cord_1),
	.result_cord_2(result_cord_2),
	.result_cord_3(result_cord_3),
	.result_cord_4(result_cord_4),
	.result_cord_5(result_cord_5),
	.result_cord_6(result_cord_6),
	.result_cord_7(result_cord_7),
	.divided_by_zero_from_DIV(divide_by_0_wire)
);

integer_to_fixed_point_and_concatenating integer_to_fixed_point_and_concatenating (
	.result_cord_1(result_cord_1    ),
	.result_cord_2(result_cord_2    ),
	.result_cord_3(result_cord_3    ),
	.result_cord_4(result_cord_4    ),
	.result_cord_5(result_cord_5    ),
	.result_cord_6(result_cord_6    ),
	.result_cord_7(result_cord_7    ),
	.new_centroid (new_centroid_wire)
);

/*comb logic*/
assign new_centroid = output_reg;
assign divide_by_0 = divided_by_0_reg;
assign cent_cnt_nxt_block = cent_cnt_nxt_block_reg;
//assign divide_by_0 = (curr_cnt == 0) ? 1'b1 : 1'b0;

/*flip flop logic*/
always @(negedge rst_n or posedge clk) begin
	if (rst_n==0) begin
		output_reg <= 0;
		divided_by_0_reg <=0;
		cent_cnt_nxt_block_reg <= 0;
	end
	else begin
		output_reg <= 0;
		if(divider_en ==1'b1) begin
			output_reg<=new_centroid_wire;
			divided_by_0_reg<= divide_by_0_wire;
			cent_cnt_nxt_block_reg <= cent_cnt;
		end
	end
end


//mux for divisor and dividend
always @* begin
	case (cent_cnt)
		3'd0 : begin
			curr_accum = accum_1;
			curr_cnt = cnt_1;
		end
		3'd1 : begin
			curr_accum = accum_2;
			curr_cnt = cnt_2;
		end
		3'd2 : begin
			curr_accum = accum_3;
			curr_cnt = cnt_3;
		end
		3'd3 : begin
			curr_accum = accum_4;
			curr_cnt = cnt_4;
		end
		3'd4 : begin
			curr_accum = accum_5;
			curr_cnt = cnt_5;
		end
		3'd5 : begin
			curr_accum = accum_6;
			curr_cnt = cnt_6;
		end
		3'd6 : begin
			curr_accum = accum_7;
			curr_cnt = cnt_7;
		end
		3'd7 : begin
			curr_accum = accum_8;
			curr_cnt = cnt_8;
		end
		default : begin
			curr_accum = 22'b0;
			curr_cnt = 10'b1;
		end
	endcase
end



















endmodule