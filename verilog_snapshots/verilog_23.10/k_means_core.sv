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
	input [dataWidth-1:0] RAM_address,
	input [dataWidth-1:0] RAM_data,
	input W_R_RAM,
	input Go,
	
	output [addrWidth-1:0] Reg_num,
	output Reg_w_r,
	output [dataWidth-1:0] Reg_write_data,
	output interupt
	


);

endmodule : k_means_core
