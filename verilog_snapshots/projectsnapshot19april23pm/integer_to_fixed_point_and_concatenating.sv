/*------------------------------------------------------------------------------
 * File          : integer_to_fixed_point_and_concatenating.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module integer_to_fixed_point_and_concatenating
#(
		parameter
		tc_mode          = 0,
		rem_mode         =1,
		accum_width      = 7*22,
		addrWidth        = 8,
		dataWidth        = 91,
		centroid_num     =8,
		accum_cord_width = 22,
		cordinate_width  = 13,
		count_width      = 10
	)
	(
		input [accum_cord_width-1:0] result_cord_1,
		input [accum_cord_width-1:0] result_cord_2,
		input [accum_cord_width-1:0] result_cord_3,
		input [accum_cord_width-1:0] result_cord_4,
		input [accum_cord_width-1:0] result_cord_5,
		input [accum_cord_width-1:0] result_cord_6,
		input [accum_cord_width-1:0] result_cord_7,
		output [dataWidth-1:0] new_centroid
	);
	// need to adress MSB problem
	assign new_centroid[1*cordinate_width-1:0*cordinate_width] = result_cord_1[1*cordinate_width-1:0*cordinate_width];
	assign new_centroid[2*cordinate_width-1:1*cordinate_width] = result_cord_2[1*cordinate_width-1:0*cordinate_width];
	assign new_centroid[3*cordinate_width-1:2*cordinate_width] = result_cord_3[1*cordinate_width-1:0*cordinate_width];
	assign new_centroid[4*cordinate_width-1:3*cordinate_width] = result_cord_4[1*cordinate_width-1:0*cordinate_width];
	assign new_centroid[5*cordinate_width-1:4*cordinate_width] = result_cord_5[1*cordinate_width-1:0*cordinate_width];
	assign new_centroid[6*cordinate_width-1:5*cordinate_width] = result_cord_6[1*cordinate_width-1:0*cordinate_width];
	assign new_centroid[7*cordinate_width-1:6*cordinate_width] = result_cord_7[1*cordinate_width-1:0*cordinate_width];

endmodule