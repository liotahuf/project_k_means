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
	//APB IF with STUB
	input [dataWidth-1:0] ram_address,
	input [dataWidth-1:0] ram_data,
	input w_r_ram,
	input go,
	
	//IF with k-means-core
	input 	    centroid_after_converge
	input [2:0]	centroid_cnt,
	///
	output [addrWidth-1:0] reg_num,
	output reg_w_r,
	output [dataWidth-1:0] reg_write_data,
	output interupt
	
	


);

//classification_block classification_block ()
//TODO: add connection of registers from classification block to regfile of the centroids when converged

endmodule : k_means_core
