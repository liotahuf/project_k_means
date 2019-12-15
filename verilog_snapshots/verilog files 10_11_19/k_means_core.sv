/*------------------------------------------------------------------------------
 * File          : k_means_core.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Sep 25, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module k_means_core 
#(
	addrWidth = 8,
	dataWidth = 91
) 

(
	input clk,
	input rst_n,
	input [dataWidth-1:0] ram_address,
	input [dataWidth-1:0] ram_data,
	input w_r_ram,
	input go,
	
	output [addrWidth-1:0] reg_num,
	output reg_w_r,
	output [dataWidth-1:0] reg_write_data,
	output interupt
	


);

//classification_block classification_block ()

endmodule : k_means_core
