/*------------------------------------------------------------------------------
 * File          : accumulator_adder.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module accumulator_adder 
#(
	parameter
	tc_mode         = 0,
	rem_mode        =1,
	accum_width = 7*22,
	addrWidth = 8,
	dataWidth = 91, 
	centroid_num =8,
	accum_cord_width = 22,
	cordinate_width = 13,
	count_width = 10
)  
(
		input [dataWidth-1:0]  point,
		input [accum_width-1:0]  accumulator,
		//
		output [accum_width-1:0]	result
);

//first point
wire [cordinate_width -1:0] point_cord_1;
wire [cordinate_width -1:0] point_cord_2;
wire [cordinate_width -1:0] point_cord_3;
wire [cordinate_width -1:0] point_cord_4;
wire [cordinate_width -1:0] point_cord_5;
wire [cordinate_width -1:0] point_cord_6;
wire [cordinate_width -1:0] point_cord_7;

//second point
wire [accum_cord_width -1:0] accum_point_cord_1;
wire [accum_cord_width -1:0] accum_point_cord_2;
wire [accum_cord_width -1:0] accum_point_cord_3;
wire [accum_cord_width -1:0] accum_point_cord_4;
wire [accum_cord_width -1:0] accum_point_cord_5;
wire [accum_cord_width -1:0] accum_point_cord_6;
wire [accum_cord_width -1:0] accum_point_cord_7;
//
//per_cordinate_adder
wire [accum_cord_width -1:0] cord_1_result;
wire [accum_cord_width -1:0] cord_2_result;
wire [accum_cord_width -1:0] cord_3_result;
wire [accum_cord_width -1:0] cord_4_result;
wire [accum_cord_width -1:0] cord_5_result;
wire [accum_cord_width -1:0] cord_6_result;
wire [accum_cord_width -1:0] cord_7_result;


//wire assigns
assign point_cord_1 = point[cordinate_width -1:0];
assign point_cord_2 = point[2*cordinate_width -1:cordinate_width];
assign point_cord_3 = point[3*cordinate_width -1:2*cordinate_width];
assign point_cord_4 = point[4*cordinate_width -1:3*cordinate_width];
assign point_cord_5 = point[5*cordinate_width -1:4*cordinate_width];
assign point_cord_6 = point[6*cordinate_width -1:5*cordinate_width];
assign point_cord_7 = point[7*cordinate_width -1:6*cordinate_width];
//
assign accum_point_cord_1 = accumulator[accum_cord_width -1:0];
assign accum_point_cord_2 = accumulator[2*accum_cord_width -1:accum_cord_width];
assign accum_point_cord_3 = accumulator[3*accum_cord_width -1:2*accum_cord_width];
assign accum_point_cord_4 = accumulator[4*accum_cord_width -1:3*accum_cord_width];
assign accum_point_cord_5 = accumulator[5*accum_cord_width -1:4*accum_cord_width];
assign accum_point_cord_6 = accumulator[6*accum_cord_width -1:5*accum_cord_width];
assign accum_point_cord_7 = accumulator[7*accum_cord_width -1:6*accum_cord_width];
/*----comb logic----*/
assign cord_1_result = (point_cord_1 + accum_point_cord_1);
assign cord_2_result = (point_cord_2 + accum_point_cord_2);
assign cord_3_result = (point_cord_3 + accum_point_cord_3);
assign cord_4_result = (point_cord_4 + accum_point_cord_4);
assign cord_5_result = (point_cord_5 + accum_point_cord_5);
assign cord_6_result = (point_cord_6 + accum_point_cord_6);
assign cord_7_result = (point_cord_7 + accum_point_cord_7);
//
assign result = {cord_7_result,cord_6_result,cord_5_result,cord_4_result,cord_3_result,cord_2_result,cord_1_result};

endmodule

///*-----Wires-----*/


