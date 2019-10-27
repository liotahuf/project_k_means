/*------------------------------------------------------------------------------
 * File          : classification_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classification_block #(addrWidth = 8, dataWidth = 91, centroid_num =8) (
	
	input clk,
	input rst_n,
	input [dataWidth-1:0] data_from_ram,
	input pipe1_en,
	input pipe2_en,
	
	
	
	
	//controller interface
	input ram_input_reg_en,
	input [centroid_num-1 :0] centroid_en,
	input [centroid_num-1 :0] accumulators_en,
	input [centroid_num-1 :0] accumulators_cnt_en,
	
	
	//k means core
	input [dataWidth-1:0]     cen_reg1,
	input [dataWidth-1:0]     cen_reg2,
	input [dataWidth-1:0]     cen_reg3,	 
	input [dataWidth-1:0]     cen_reg4,
	input [dataWidth-1:0]     cen_reg5,
	input [dataWidth-1:0]     cen_reg6,
	input [dataWidth-1:0]     cen_reg7,
	input [dataWidth-1:0]     cen_reg8
);




/*----pipeline instances---*/



/*----Internal registers---*/




//accumulators
reg [dataWidth-1:0] accumulator_1;
reg [dataWidth-1:0] accumulator_2;
reg [dataWidth-1:0] accumulator_3;
reg [dataWidth-1:0] accumulator_4;
reg [dataWidth-1:0] accumulator_5;
reg [dataWidth-1:0] accumulator_6;
reg [dataWidth-1:0] accumulator_7;
reg [dataWidth-1:0] accumulator_8;


//accumulators counters
reg [dataWidth-1:0] accumulator_cnt_1;
reg [dataWidth-1:0] accumulator_cnt_2;
reg [dataWidth-1:0] accumulator_cnt_3;
reg [dataWidth-1:0] accumulator_cnt_4;
reg [dataWidth-1:0] accumulator_cnt_5;
reg [dataWidth-1:0] accumulator_cnt_6;
reg [dataWidth-1:0] accumulator_cnt_7;
reg [dataWidth-1:0] accumulator_cnt_8;




/*----Wires----*/
//wire [dataWidth-1 :0] distance_1;
//wire [dataWidth-1 :0] distance_2;
//wire [dataWidth-1 :0] distance_3;
//wire [dataWidth-1 :0] distance_4;
//wire [dataWidth-1 :0] distance_5;
//wire [dataWidth-1 :0] distance_6;
//wire [dataWidth-1 :0] distance_7;
//wire [dataWidth-1 :0] distance_8;







endmodule : classification_block