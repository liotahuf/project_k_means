/*------------------------------------------------------------------------------
 * File          : controller.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Dec 15, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module controller #(
	tc_mode           = 1,
	rem_mode          =1,
	accum_width       = 7*22,
	addrWidth         = 8,
	dataWidth         = 91,
	centroid_num      =8,
	log2_cent_num     = 3,
	accum_cord_width  = 22,
	cordinate_width   = 13,
	count_width       = 10,
	manhatten_width   = 16, //protect from overflow
	log2_of_point_cnt = 9
) (
	input                          clk,
	input                          rst_n,
	
	//input from k_means_core
	input                          go,
	input  [log2_of_point_cnt-1:0] first_ram_addr,     //TODO : need to see where and how we get this value
	output [log2_of_point_cnt-1:0] last_ram_addr,      //TODO : need to see where and how we get this value
	
	//TODO - IF with RAM
	output                         w_r_ram,
	output [log2_of_point_cnt-1:0] ram_addr,
	
	//IF with classification block
	output                         ram_input_reg_en,
	output [centroid_num-1 :0]     centroid_en,
	output                         accumulators_en,
	output                         pipe3_regs_reset_n, //pipe3
	
	//IF with new_means_calculation_block
	output                         divider_en,
	output [2:0]                   cent_cnt,
	
	//IF with convergence check block
	output                         convergence_reg_en,
	output                         convergence_regs_reset,
	input                          has_converged,
	input                          converge_res_available
	
);


/*----------WIRES & REGS-------------*/

reg [log2_of_point_cnt-1:0] point_cnt;
reg [log2_cent_num-1:0]  centroid_cnt;
reg [1:0] fill_cnt;//fill classification block pipe // TODO - might fix to 1 bit because its up to 3 or up to 2



































endmodule : controller