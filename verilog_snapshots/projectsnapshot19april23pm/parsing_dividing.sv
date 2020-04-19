/*------------------------------------------------------------------------------
 * File          : parsing_dividing.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module parsing_dividing #(
	parameter
	tc_mode          = 1,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10
) (
	input [accum_width-1:0] accumulator,
	input [count_width-1:0] counter,
	//
	output [accum_cord_width-1:0] result_cord_1,
	output [accum_cord_width-1:0] result_cord_2,
	output [accum_cord_width-1:0] result_cord_3,
	output [accum_cord_width-1:0] result_cord_4,
	output [accum_cord_width-1:0] result_cord_5,
	output [accum_cord_width-1:0] result_cord_6,
	output [accum_cord_width-1:0] result_cord_7,
	output divided_by_zero_from_DIV
);
/*------WIRES-------*/
//accum point cordinates
wire [accum_cord_width -1:0] accum_point_cord_1;
wire [accum_cord_width -1:0] accum_point_cord_2;
wire [accum_cord_width -1:0] accum_point_cord_3;
wire [accum_cord_width -1:0] accum_point_cord_4;
wire [accum_cord_width -1:0] accum_point_cord_5;
wire [accum_cord_width -1:0] accum_point_cord_6;
wire [accum_cord_width -1:0] accum_point_cord_7;
//quetinents by cordinates
wire [accum_cord_width -1:0] quot_cord_1;
wire [accum_cord_width -1:0] quot_cord_2;
wire [accum_cord_width -1:0] quot_cord_3;
wire [accum_cord_width -1:0] quot_cord_4;
wire [accum_cord_width -1:0] quot_cord_5;
wire [accum_cord_width -1:0] quot_cord_6;
wire [accum_cord_width -1:0] quot_cord_7;
//divide by 0 per cordinate
wire divide_by_0_cord_1;
wire divide_by_0_cord_2;
wire divide_by_0_cord_3;
wire divide_by_0_cord_4;
wire divide_by_0_cord_5;
wire divide_by_0_cord_6;
wire divide_by_0_cord_7;

/*-------COMB LOGIC---------*/
assign accum_point_cord_1 = accumulator[accum_cord_width -1:0];
assign accum_point_cord_2 = accumulator[2*accum_cord_width -1:accum_cord_width];
assign accum_point_cord_3 = accumulator[3*accum_cord_width -1:2*accum_cord_width];
assign accum_point_cord_4 = accumulator[4*accum_cord_width -1:3*accum_cord_width];
assign accum_point_cord_5 = accumulator[5*accum_cord_width -1:4*accum_cord_width];
assign accum_point_cord_6 = accumulator[6*accum_cord_width -1:5*accum_cord_width];
assign accum_point_cord_7 = accumulator[7*accum_cord_width -1:6*accum_cord_width];
//
assign result_cord_1 = quot_cord_1;
assign result_cord_2 = quot_cord_2;
assign result_cord_3 = quot_cord_3;
assign result_cord_4 = quot_cord_4;
assign result_cord_5 = quot_cord_5;
assign result_cord_6 = quot_cord_6;
assign result_cord_7 = quot_cord_7;

assign divided_by_zero_from_DIV = divide_by_0_cord_1;

/*-------Instantiation---------*/
DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_1 (
	.a          (accum_point_cord_1),
	.b          (counter           ),
	.quotient   (quot_cord_1       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_1)
);

DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_2 (
	.a          (accum_point_cord_2),
	.b          (counter           ),
	.quotient   (quot_cord_2       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_2)
);

DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_3 (
	.a          (accum_point_cord_3),
	.b          (counter           ),
	.quotient   (quot_cord_3       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_3)
);

DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_4 (
	.a          (accum_point_cord_4),
	.b          (counter           ),
	.quotient   (quot_cord_4       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_4)
);

DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_5 (
	.a          (accum_point_cord_5),
	.b          (counter           ),
	.quotient   (quot_cord_5       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_5)
);

DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_6 (
	.a          (accum_point_cord_6),
	.b          (counter           ),
	.quotient   (quot_cord_6       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_6)
);

DW_div #(
	accum_cord_width,
	count_width,
	tc_mode,
	rem_mode
)
DIV_7 (
	.a          (accum_point_cord_7),
	.b          (counter           ),
	.quotient   (quot_cord_7       ),
	.remainder  (                  ),
	.divide_by_0(divide_by_0_cord_7)
);




endmodule