/*------------------------------------------------------------------------------
 * File          : demux.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 3, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module demux #(parameter input_width = 91) 
(
	input [input_width-1:0] data_in,
	input [3:0] 		  index,
	//
	output [input_width-1:0] data_out_1,
	output [input_width-1:0] data_out_2,
	output [input_width-1:0] data_out_3,
	output [input_width-1:0] data_out_4,
	output [input_width-1:0] data_out_5,
	output [input_width-1:0] data_out_6,
	output [input_width-1:0] data_out_7,
	output [input_width-1:0] data_out_8
);

reg [input_width-1:0] data_out_reg1;
assign data_out_1 = data_out_reg1;

reg [input_width-1:0] data_out_reg2;
assign data_out_2 = data_out_reg2;

reg [input_width-1:0] data_out_reg3;
assign data_out_3 = data_out_reg3;

reg [input_width-1:0] data_out_reg4;
assign data_out_4 = data_out_reg4;

reg [input_width-1:0] data_out_reg5;
assign data_out_5 = data_out_reg5;

reg [input_width-1:0] data_out_reg6;
assign data_out_6 = data_out_reg6;

reg [input_width-1:0] data_out_reg7;
assign data_out_7 = data_out_reg7;

reg [input_width-1:0] data_out_reg8;
assign data_out_8 = data_out_reg8;


always @(index,data_in) begin
	data_out_reg1 =0;
	data_out_reg2 =0;
	data_out_reg3 =0;
	data_out_reg4 =0;
	data_out_reg5 =0;
	data_out_reg6 =0;
	data_out_reg7 =0;
	data_out_reg8 =0;
	
	
	case (index)
		4'd1 : data_out_reg1 = data_in;
		4'd2 : data_out_reg2 = data_in;
		4'd3 : data_out_reg3 = data_in;
		4'd4 : data_out_reg4 = data_in;
		4'd5 : data_out_reg5 = data_in;
		4'd6 : data_out_reg6 = data_in;
		4'd7 : data_out_reg7 = data_in;
		4'd8 : data_out_reg8 = data_in;
	endcase
		
end

endmodule