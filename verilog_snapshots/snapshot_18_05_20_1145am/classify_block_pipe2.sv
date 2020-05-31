/*------------------------------------------------------------------------------
 * File          : classify_block_pipe2.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/
//TODO : before syntesys we can actually drop the clk from here if possible with timing constraints
module classify_block_pipe2 
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
	input clk,
	input rst_n,
	input [dataWidth-1 :0]    distance_1,
	input [dataWidth-1 :0]    distance_2,
	input [dataWidth-1 :0]    distance_3,
	input [dataWidth-1 :0]    distance_4,
	input [dataWidth-1 :0]    distance_5,
	input [dataWidth-1 :0]    distance_6,
	input [dataWidth-1 :0]    distance_7,
	input [dataWidth-1 :0]    distance_8,
	//
	output [3:0] index,
	//
	input [dataWidth-1:0]    point_from_pipe1,
	output [dataWidth-1:0]    point_to_pipe3
	
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

/*-----Registers-----*/
reg [dataWidth-1 :0]    dist_reg_1;
reg [dataWidth-1 :0]    dist_reg_2;
reg [dataWidth-1 :0]    dist_reg_3;
reg [dataWidth-1 :0]    dist_reg_4;
reg [dataWidth-1 :0]    dist_reg_5;
reg [dataWidth-1 :0]    dist_reg_6;
reg [dataWidth-1 :0]    dist_reg_7;
reg [dataWidth-1 :0]    dist_reg_8;
//pipe3
reg [dataWidth-1:0]     point;


/*----comb logic----*/
//first level
assign min_dist_first_level_1 = (dist_reg_1 < dist_reg_2) ? dist_reg_1 : dist_reg_2;
assign index_first_level_1 = (dist_reg_1 < dist_reg_2) ? 4'd1 : 4'd2;

assign min_dist_first_level_2 = (dist_reg_3 < dist_reg_4) ? dist_reg_3 : dist_reg_4;
assign index_first_level_2 = (dist_reg_3 < dist_reg_4) ? 4'd3 : 4'd4;

assign min_dist_first_level_3 = (dist_reg_5 < dist_reg_6) ? dist_reg_5 : dist_reg_6;
assign index_first_level_3 = (dist_reg_5 < dist_reg_6) ? 4'd5 : 4'd6;

assign min_dist_first_level_4 = (dist_reg_7 < dist_reg_8) ? dist_reg_7 : dist_reg_8;
assign index_first_level_4 = (dist_reg_7 < dist_reg_8) ? 4'd7 : 4'd8;

//second level
assign min_dist_second_level_1 = (min_dist_first_level_1 < min_dist_first_level_2) ? min_dist_first_level_1 : min_dist_first_level_2;
assign index_second_level_1 = (min_dist_first_level_1 < min_dist_first_level_2) ? index_first_level_1 : index_first_level_2;

assign min_dist_second_level_2 = (min_dist_first_level_3 < min_dist_first_level_4) ? min_dist_first_level_3 : min_dist_first_level_4;
assign index_second_level_2 = (min_dist_first_level_3 < min_dist_first_level_4) ? index_first_level_3 : index_first_level_4;

//third level
assign index = (min_dist_second_level_1 < min_dist_second_level_2) ? index_second_level_1 : index_second_level_2;

//to pipe3
assign point_to_pipe3 = point;

/*flip flop logic*/
always @(negedge rst_n or posedge clk) begin
	if (rst_n==0) begin
		dist_reg_1 <= 91'b0;
		dist_reg_2 <= 91'b0;
		dist_reg_3 <= 91'b0;
		dist_reg_4 <= 91'b0;
		dist_reg_5 <= 91'b0;
		dist_reg_6 <= 91'b0;
		dist_reg_7 <= 91'b0;
		dist_reg_8 <= 91'b0;
		point	   <= 91'b0;
	end
	else begin
		dist_reg_1 <= distance_1;
		dist_reg_2 <= distance_2;
		dist_reg_3 <= distance_3;
		dist_reg_4 <= distance_4;
		dist_reg_5 <= distance_5;
		dist_reg_6 <= distance_6;
		dist_reg_7 <= distance_7;
		dist_reg_8 <= distance_8;
		point	   <= point_from_pipe1;
	end
end
	





endmodule