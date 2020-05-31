/*------------------------------------------------------------------------------
 * File          : classify_block_pipe1.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classify_block_pipe1 #(
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
) (
	input                      clk,
	input                      rst_n,
	
	//IF controller
	input  [centroid_num-1 :0] centroid_en,
	input                      first_iteration,
	//IF to classification block(shell)
	input  [dataWidth-1:0]     centroid_input_from_core,
	//output [dataWidth-1:0]     centroid_output_to_core, //TODO - eddy rmv 21.4.20
	//centroid_reg_input_1
	
	////IF with convergence check block
	input  [2:0]               cent_cnt,
	input  [dataWidth-1:0]     new_centroid,
	output [dataWidth-1:0]     centroid_reg_output_1,
	output [dataWidth-1:0]     centroid_reg_output_2,
	output [dataWidth-1:0]     centroid_reg_output_3,
	output [dataWidth-1:0]     centroid_reg_output_4,
	output [dataWidth-1:0]     centroid_reg_output_5,
	output [dataWidth-1:0]     centroid_reg_output_6,
	output [dataWidth-1:0]     centroid_reg_output_7,
	output [dataWidth-1:0]     centroid_reg_output_8,
	
	//IF with RAM
	input  [dataWidth-1:0]     data_from_ram,
	input                      input_reg_en,            //from controller
	
	//IF with pipe2 of classification block
	output [dataWidth-1 :0]    distance_1,
	output [dataWidth-1 :0]    distance_2,
	output [dataWidth-1 :0]    distance_3,
	output [dataWidth-1 :0]    distance_4,
	output [dataWidth-1 :0]    distance_5,
	output [dataWidth-1 :0]    distance_6,
	output [dataWidth-1 :0]    distance_7,
	output [dataWidth-1 :0]    distance_8,
	output [dataWidth-1:0]     point_to_pipe2
	
);

//input register from ram
reg [dataWidth-1:0] input_register;
/*explanation: cent cnt is used by divider block, and we need to wait 2 cycls until we can sample results,
from the cent_cnt we got from controller*/
reg [2:0] cent_cnt_d;
reg [2:0] cent_cnt_2d;

/*----Internal registers---*/

//centroids
reg [dataWidth-1:0] centroid_1;
reg [dataWidth-1:0] centroid_2;
reg [dataWidth-1:0] centroid_3;
reg [dataWidth-1:0] centroid_4;
reg [dataWidth-1:0] centroid_5;
reg [dataWidth-1:0] centroid_6;
reg [dataWidth-1:0] centroid_7;
reg [dataWidth-1:0] centroid_8;


/*----Internal blocks---*/
distance_calc distance_calc_1 (
	.first_point (centroid_1    ),
	.second_point(input_register),
	.distance    (distance_1    )
);

distance_calc distance_calc_2 (
	.first_point (centroid_2    ),
	.second_point(input_register),
	.distance    (distance_2    )
);

distance_calc distance_calc_3 (
	.first_point (centroid_3    ),
	.second_point(input_register),
	.distance    (distance_3    )
);

distance_calc distance_calc_4 (
	.first_point (centroid_4    ),
	.second_point(input_register),
	.distance    (distance_4    )
);

distance_calc distance_calc_5 (
	.first_point (centroid_5    ),
	.second_point(input_register),
	.distance    (distance_5    )
);

distance_calc distance_calc_6 (
	.first_point (centroid_6    ),
	.second_point(input_register),
	.distance    (distance_6    )
);

distance_calc distance_calc_7 (
	.first_point (centroid_7    ),
	.second_point(input_register),
	.distance    (distance_7    )
);

distance_calc distance_calc_8 (
	.first_point (centroid_8    ),
	.second_point(input_register),
	.distance    (distance_8    )
);

/*comb logic*/
assign point_to_pipe2 = input_register;
//output old centroid registers to convergence check block
assign centroid_reg_output_1 = centroid_1;
assign centroid_reg_output_2 = centroid_2;
assign centroid_reg_output_3 = centroid_3;
assign centroid_reg_output_4 = centroid_4;
assign centroid_reg_output_5 = centroid_5;
assign centroid_reg_output_6 = centroid_6;
assign centroid_reg_output_7 = centroid_7;
assign centroid_reg_output_8 = centroid_8;

/*flipflop logic*/

//cent cnt delay and 2nd delay
always @(negedge rst_n or posedge clk) begin
	if (rst_n==0) begin
		cent_cnt_d <= 0;
		cent_cnt_2d <= 0;
	end
	else begin
		cent_cnt_d <= cent_cnt;
		cent_cnt_2d <= cent_cnt_d;
	end
end

always @(negedge rst_n or posedge clk) begin
	if (rst_n==0) begin
		centroid_1 <= 91'b0;
		centroid_2 <= 91'b0;
		centroid_3 <= 91'b0;
		centroid_4 <= 91'b0;
		centroid_5 <= 91'b0;
		centroid_6 <= 91'b0;
		centroid_7 <= 91'b0;
		centroid_8 <= 91'b0;
		input_register <= 91'b0;
		
	end
	else begin
		input_register <= input_reg_en ? data_from_ram : input_register;
		if(first_iteration) begin
			centroid_1 <= centroid_en[0] ? centroid_input_from_core : centroid_1;
			centroid_2 <= centroid_en[1] ? centroid_input_from_core : centroid_2;
			centroid_3 <= centroid_en[2] ? centroid_input_from_core : centroid_3;
			centroid_4 <= centroid_en[3] ? centroid_input_from_core : centroid_4;
			centroid_5 <= centroid_en[4] ? centroid_input_from_core : centroid_5;
			centroid_6 <= centroid_en[5] ? centroid_input_from_core : centroid_6;
			centroid_7 <= centroid_en[6] ? centroid_input_from_core : centroid_7;
			centroid_8 <= centroid_en[7] ? centroid_input_from_core : centroid_8;
		end
		else begin
			case (cent_cnt_2d)
				3'd0 : begin
					centroid_1 <= centroid_en[0] ? new_centroid : centroid_1;
				end
				3'd1 : begin
					centroid_2 <= centroid_en[1] ? new_centroid : centroid_2;
				end
				3'd2 : begin
					centroid_3 <= centroid_en[2] ? new_centroid : centroid_3;
				end
				3'd3 : begin
					centroid_4 <= centroid_en[3] ? new_centroid : centroid_4;
				end
				3'd4 : begin
					centroid_5 <= centroid_en[4] ? new_centroid : centroid_5;
				end
				3'd5 : begin
					centroid_6 <= centroid_en[5] ? new_centroid : centroid_6;
				end
				3'd6 : begin
					centroid_7 <= centroid_en[6] ? new_centroid : centroid_7;
				end
				3'd7 : begin
					centroid_8 <= centroid_en[7] ? new_centroid : centroid_8;
				end
			endcase
		end
		
	end
end




endmodule