/*------------------------------------------------------------------------------
 * File          : classify_block_pipe1.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classify_block_pipe1 #(addrWidth = 8, dataWidth = 91, centroid_num =8) (
	input                      clk,
	input                      rst_n,
	//
	input  [centroid_num-1 :0] centroid_en,
	input  [dataWidth-1:0]     centroid_reg_input_1,
	input  [dataWidth-1:0]     centroid_reg_input_2,
	input  [dataWidth-1:0]     centroid_reg_input_3,
	input  [dataWidth-1:0]     centroid_reg_input_4,
	input  [dataWidth-1:0]     centroid_reg_input_5,
	input  [dataWidth-1:0]     centroid_reg_input_6,
	input  [dataWidth-1:0]     centroid_reg_input_7,
	input  [dataWidth-1:0]     centroid_reg_input_8,
	//
	input  [dataWidth-1:0]     data_from_ram,
	input  					   input_reg_en,
	//
	output [dataWidth-1 :0]    distance_1,
	output [dataWidth-1 :0]    distance_2,
	output [dataWidth-1 :0]    distance_3,
	output [dataWidth-1 :0]    distance_4,
	output [dataWidth-1 :0]    distance_5,
	output [dataWidth-1 :0]    distance_6,
	output [dataWidth-1 :0]    distance_7,
	output [dataWidth-1 :0]    distance_8
	
);


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


//input register from ram
reg [dataWidth-1:0] input_register;



/*----comb logic----*/
assign distance_1 = (centroid_1 > input_register) ?  (centroid_1 - input_register) : (input_register - centroid_1);
assign distance_2 = (centroid_2 > input_register) ?  (centroid_2 - input_register) : (input_register - centroid_2);
assign distance_3 = (centroid_3 > input_register) ?  (centroid_3 - input_register) : (input_register - centroid_3);
assign distance_4 = (centroid_4 > input_register) ?  (centroid_4 - input_register) : (input_register - centroid_4);
assign distance_5 = (centroid_5 > input_register) ?  (centroid_5 - input_register) : (input_register - centroid_5);
assign distance_6 = (centroid_6 > input_register) ?  (centroid_6 - input_register) : (input_register - centroid_6);
assign distance_7 = (centroid_7 > input_register) ?  (centroid_7 - input_register) : (input_register - centroid_7);
assign distance_8 = (centroid_8 > input_register) ?  (centroid_8 - input_register) : (input_register - centroid_8);

/*flipflop logic*/
always @(rst_n==0 or posedge clk) begin
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
		centroid_1 <= centroid_en[0] ? centroid_reg_input_1 : centroid_1;
		centroid_2 <= centroid_en[1] ? centroid_reg_input_2 : centroid_2;
		centroid_3 <= centroid_en[2] ? centroid_reg_input_3 : centroid_3;
		centroid_4 <= centroid_en[3] ? centroid_reg_input_4 : centroid_4;
		centroid_5 <= centroid_en[4] ? centroid_reg_input_5 : centroid_5;
		centroid_6 <= centroid_en[5] ? centroid_reg_input_6 : centroid_6;
		centroid_7 <= centroid_en[6] ? centroid_reg_input_7 : centroid_7;
		centroid_8 <= centroid_en[7] ? centroid_reg_input_8 : centroid_8;
		input_register <= input_reg_en ? data_from_ram : input_register;
	end
end





always@ ()


endmodule : classify_block_pipe1