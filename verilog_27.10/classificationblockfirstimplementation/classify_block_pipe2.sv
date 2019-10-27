/*------------------------------------------------------------------------------
 * File          : classify_block_pipe2.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classify_block_pipe2 #(addrWidth = 8, dataWidth = 91, centroid_num =8) 
(
	input [dataWidth-1 :0]    distance_1,
	input [dataWidth-1 :0]    distance_2,
	input [dataWidth-1 :0]    distance_3,
	input [dataWidth-1 :0]    distance_4,
	input [dataWidth-1 :0]    distance_5,
	input [dataWidth-1 :0]    distance_6,
	input [dataWidth-1 :0]    distance_7,
	input [dataWidth-1 :0]    distance_8,
	
	output [3:0] index
	
);

/*----Wires----*/
wire [dataWidth-1 :0] min_dist_first_level_1;
wire [dataWidth-1 :0] min_dist_first_level_2;
wire [dataWidth-1 :0] min_dist_first_level_3;
wire [dataWidth-1 :0] min_dist_first_level_4;
//
wire [dataWidth-1 :0] min_dist_second_level_1;
wire [dataWidth-1 :0] min_dist_second_level_2;
//
wire [3:0] index_first_level_1;
wire [3:0] index_first_level_2;
wire [3:0] index_first_level_3;
wire [3:0] index_first_level_4;
//
wire [3:0] index_second_level_1;
wire [3:0] index_second_level_2;


/*----comb logic----*/
//first level
assign min_dist_first_level_1 = (distance_1 < distance_2) ? distance_1 : distance_2;
assign index_first_level_1 = (distance_1 < distance_2) ? 1'd1 : 1'd2;

assign min_dist_first_level_2 = (distance_3 < distance_4) ? distance_3 : distance_4;
assign index_first_level_2 = (distance_3 < distance_4) ? 1'd3 : 1'd4;

assign min_dist_first_level_3 = (distance_5 < distance_6) ? distance_5 : distance_6;
assign index_first_level_3 = (distance_5 < distance_6) ? 1'd5 : 1'd6;

assign min_dist_first_level_4 = (distance_7 < distance_8) ? distance_7 : distance_8;
assign index_first_level_4 = (distance_7 < distance_8) ? 1'd7 : 1'd8;

//second level
assign min_dist_second_level_1 = (min_dist_first_level_1 < min_dist_first_level_2) ? min_dist_first_level_1 : min_dist_first_level_2;
assign index_second_level_1 = (min_dist_first_level_1 < min_dist_first_level_2) ? index_first_level_1 : index_first_level_2;

assign min_dist_second_level_2 = (min_dist_first_level_3 < min_dist_first_level_4) ? min_dist_first_level_3 : min_dist_first_level_4;
assign index_second_level_2 = (min_dist_first_level_3 < min_dist_first_level_4) ? index_first_level_3 : index_first_level_4;

//third level
assign index = (min_dist_second_level_1 < min_dist_second_level_2) ? index_second_level_1 : index_second_level_2;


endmodule : classify_block_pipe2