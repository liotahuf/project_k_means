/*------------------------------------------------------------------------------
 * File          : k_means_core.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Sep 25, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

`timescale 1ns/1fs


`define numAddr 9
`define numOut 50
`define wordDepth 512

`define verbose 3
`ifdef verbose_0
`undef verbose
`define verbose 0
`endif
`ifdef verbose_1
`undef verbose
`define  verbose 1
`endif
`ifdef verbose_2
`undef verbose
`define verbose 2
`endif
`ifdef verbose_3
`undef verbose
`define verbose 3
`endif

`ifdef POLARIS_CBS
`define mintimestep
`else
`define mintimestep #0.01
`endif

`celldefine

module k_means_core #(
	parameter
	tc_mode           = 1,
	rem_mode          =1,
	accum_width       = 7*22,
	addrWidth         = 9,
	dataWidth         = 91,
	centroid_num      =8,
	log2_cent_num     = 3,
	accum_cord_width  = 22,
	cordinate_width   = 13,
	count_width       = 10,
	manhatten_width   = 16, //protect from overflow
	log2_of_point_cnt = 9,
	ram_word_len      = 50,
	reg_amount        = 8
	
	
) (
	input                        clk,
	input                        rst_n,
	//IF with REGFILE
	input  [dataWidth-1:0]       adress2core,
	input  [dataWidth-1:0]       data2core,
	input                        go_core,
	input  [addrWidth-1:0]       first_ram_address,
	input  [addrWidth-1:0]       last_ram_address,
	input  [manhatten_width-1:0] threshold_value,
	input                        W_R_RAM_N,
	input                        CHIP_SEL_RAM_N,
	
	
	///
	output [reg_amount-1:0]      reg_num,
	output                       reg_w_r,
	output [dataWidth-1:0]       Reg_write_data_from_core,
	output                       interupt
);


enum logic [7:0] { internal_status_reg,go_reg,cent_1_reg,cent_2_reg,cent_3_reg,cent_4_reg,cent_5_reg,cent_6_reg,cent_7_reg,cent_8_reg,
	               RAM_addr_reg,RAM_data_reg,first_ram_addr_reg,last_ram_addr_reg} register_num;

/*--------------CORE--------------*/

//RAM's I/O
wire [ram_word_len-1:0] RAM1_data_out;
wire [ram_word_len-1:0] RAM2_data_out;
wire [dataWidth-1:0] RAMs_out_data_merged;
//wire [ram_word_len-1:0] RAM1_data_in;
//wire [ram_word_len-1:0] RAM2_data_in;
reg [`numAddr-1:0] RAMs_adress;
reg [`numOut-1:0] RAM1_data_in;
reg [`numOut-1:0] RAM2_data_in;

//controller to RAM
wire [addrWidth-1:0] RAM_adress_from_controller;
wire web_from_controller;
wire oeb_from_controller;
wire csb_from_controller;

//controller to RegFile
//wire go_core;
wire [addrWidth-1:0]first_ram_adress;
wire [addrWidth-1:0]last_ram_addr;
wire [reg_amount-1:0]reg_num_wire;
wire reg_write;
wire interrupt;
wire go_signal;
reg [dataWidth-1:0] Reg_write_data_from_core_wire;


//classification_block with new_means_calculation_block interface aka (block_1 with block_2)
//	->
wire [accum_width-1:0]   accum_1;
wire [accum_width-1:0]   accum_2;
wire [accum_width-1:0]   accum_3;
wire [accum_width-1:0]   accum_4;
wire [accum_width-1:0]   accum_5;
wire [accum_width-1:0]   accum_6;
wire [accum_width-1:0]   accum_7;
wire [accum_width-1:0]   accum_8;
//
wire [count_width-1:0]   cnt_1;
wire [count_width-1:0]   cnt_2;
wire [count_width-1:0]   cnt_3;
wire [count_width-1:0]   cnt_4;
wire [count_width-1:0]   cnt_5;
wire [count_width-1:0]   cnt_6;
wire [count_width-1:0]   cnt_7;
wire [count_width-1:0]   cnt_8;

//classification_block with convergence_check_block interface aka (block_1 with block_3)
// ->
wire [dataWidth-1:0]     old_centroid_reg_1;
wire [dataWidth-1:0]     old_centroid_reg_2;
wire [dataWidth-1:0]     old_centroid_reg_3;
wire [dataWidth-1:0]     old_centroid_reg_4;
wire [dataWidth-1:0]     old_centroid_reg_5;
wire [dataWidth-1:0]     old_centroid_reg_6;
wire [dataWidth-1:0]     old_centroid_reg_7;
wire [dataWidth-1:0]     old_centroid_reg_8;
// <-
wire [dataWidth-1:0]     new_centroid_out;
//new_means_calculation_block with convergence_check_block interface aka (block_2 with block_3)
// ->
wire [2:0]			 	cent_cnt_nxt_block;
wire                   divide_by_0;
wire [dataWidth-1:0]   new_centroid_in;




//garbage below until reused later:
// wires out from controller to core(not used yet)
wire ram_input_reg_en;

wire [7:0]centroid_en ;
wire accumulators_en;
wire pipe3_regs_reset_n;
wire first_iteration ;
wire divider_en;
wire [log2_cent_num-1:0]cent_cnt;
wire [2:0]wr_cnvrg_to_calc_cent_num;
wire convergence_reg_en;
wire convergence_regs_reset_n;
wire has_converged;
wire converge_res_available;

reg web;
reg oeb;
reg csb;


//RAMs
spram512x50_cb RAM_1 (
	.A  (RAMs_adress  ),
	.CEB(clk          ),
	.WEB(web          ),
	.OEB(oeb          ),
	.CSB(csb          ),
	.I  (RAM1_data_in ),
	.O  (RAM1_data_out)
);

spram512x50_cb RAM_2 (
	.A  (RAMs_adress  ),
	.CEB(clk          ),
	.WEB(web          ),
	.OEB(oeb          ),
	.CSB(csb          ),
	.I  (RAM2_data_in ),
	.O  (RAM2_data_out)
);

/**----------Controller---------*/

controller #(
	.tc_mode          (tc_mode          ),
	.rem_mode         (rem_mode         ),
	.accum_width      (accum_width      ),
	.addrWidth        (addrWidth        ),
	.dataWidth        (dataWidth        ),
	.centroid_num     (centroid_num     ),
	.log2_cent_num    (log2_cent_num    ),
	.accum_cord_width (accum_cord_width ),
	.cordinate_width  (cordinate_width  ),
	.count_width      (count_width      ),
	.manhatten_width  (manhatten_width  ),
	.log2_of_point_cnt(log2_of_point_cnt),
	.ram_word_len     (ram_word_len     ),
	.reg_amount       (reg_amount       )
) u_controller (
	.clk                      (clk                       ),
	.rst_n                    (rst_n                     ),
	//in from REGFILE
	.go                       (go_core                   ),
	.first_ram_addr           (first_ram_address         ),
	.last_ram_addr            (last_ram_address          ),
	//out to REGFILE
	.reg_write                (reg_w_r                   ),
	.reg_num                  (reg_num_wire              ),
	.interupt                 (interupt                  ),
	//controller to RAM's
	.go_signal                (go_signal                 ),
	.ram_addr                 (RAM_adress_from_controller),
	.wr_en_n                  (web_from_controller       ),
	.output_en_n              (oeb_from_controller       ),
	.chip_select_n            (csb_from_controller       ),
	//controller to classify_block
	.cent_cnt                 (cent_cnt                  ),
	.ram_input_reg_en         (ram_input_reg_en          ),
	.centroid_en              (centroid_en               ),
	.accumulators_en          (accumulators_en           ),
	.pipe3_regs_reset_n       (pipe3_regs_reset_n        ),
	.first_iteration          (first_iteration           ),
	//controller to new_means_calc block
	.divider_en               (divider_en                ), //not for now
	//conntroller to cnvrg block
	.wr_cnvrg_to_calc_cent_num(wr_cnvrg_to_calc_cent_num ), //not for now
	.convergence_reg_en       (convergence_reg_en        ), //not for now
	.convergence_regs_reset_n (convergence_regs_reset_n  ), //not for now
	.has_converged            (has_converged             ), //not for now
	.converge_res_available   (converge_res_available    )  //not for now
);



//BLOCK 1
classification_block #(
	.tc_mode         (tc_mode         ),
	.rem_mode        (rem_mode        ),
	.accum_width     (accum_width     ),
	.addrWidth       (addrWidth       ),
	.dataWidth       (dataWidth       ),
	.centroid_num    (centroid_num    ),
	.accum_cord_width(accum_cord_width),
	.cordinate_width (cordinate_width ),
	.count_width     (count_width     ),
	.reg_amount      (reg_amount      )
) u_classification_block (
	.clk               (clk                 ),
	.rst_n             (rst_n               ),
	
	//ram interface
	.data_from_ram     (RAMs_out_data_merged),
	
	//controller interface
	.ram_input_reg_en  (ram_input_reg_en    ),
	.centroid_en       (centroid_en         ),
	.accumulators_en   (accumulators_en     ),
	.pipe3_regs_reset_n(pipe3_regs_reset_n  ),
	.first_iteration   (first_iteration     ),
	
	//k means core IF
	.data_from_regfile (data2core           ),
	//.data_to_regfile   (data_to_regfile                             ), //not for now - eddy rmv 21.4.20
	
	//IF with new means calculation block
	//output
	//not for now all below
	.accum_1           (accum_1             ),
	.accum_2           (accum_2             ),
	.accum_3           (accum_3             ),
	.accum_4           (accum_4             ),
	.accum_5           (accum_5             ),
	.accum_6           (accum_6             ),
	.accum_7           (accum_7             ),
	.accum_8           (accum_8             ),
	.cnt_1             (cnt_1               ),
	.cnt_2             (cnt_2               ),
	.cnt_3             (cnt_3               ),
	.cnt_4             (cnt_4               ),
	.cnt_5             (cnt_5               ),
	.cnt_6             (cnt_6               ),
	.cnt_7             (cnt_7               ),
	.cnt_8             (cnt_8               ),
	//IF with convergence check block, and with k-means-core - fan out to both of them
	//output
	.centroid_reg_1    (old_centroid_reg_1  ),
	.centroid_reg_2    (old_centroid_reg_2  ),
	.centroid_reg_3    (old_centroid_reg_3  ),
	.centroid_reg_4    (old_centroid_reg_4  ),
	.centroid_reg_5    (old_centroid_reg_5  ),
	.centroid_reg_6    (old_centroid_reg_6  ),
	.centroid_reg_7    (old_centroid_reg_7  ),
	.centroid_reg_8    (old_centroid_reg_8  ),
	//input
	.cent_cnt          (cent_cnt            ),
	.new_centroid      (new_centroid_out    )
);

//BLOCK 2
new_means_calculation_block #(
	.tc_mode         (tc_mode         ),
	.rem_mode        (rem_mode        ),
	.accum_width     (accum_width     ),
	.count_width     (count_width     ),
	.addrWidth       (addrWidth       ),
	.dataWidth       (dataWidth       ),
	.centroid_num    (centroid_num    ),
	.cordinate_width (cordinate_width ),
	.accum_cord_width(accum_cord_width)
) u_new_means_calculation_block (
	.clk               (clk               ),
	.rst_n             (rst_n             ),
	.accum_1           (accum_1           ),
	.accum_2           (accum_2           ),
	.accum_3           (accum_3           ),
	.accum_4           (accum_4           ),
	.accum_5           (accum_5           ),
	.accum_6           (accum_6           ),
	.accum_7           (accum_7           ),
	.accum_8           (accum_8           ),
	.cnt_1             (cnt_1             ),
	.cnt_2             (cnt_2             ),
	.cnt_3             (cnt_3             ),
	.cnt_4             (cnt_4             ),
	.cnt_5             (cnt_5             ),
	.cnt_6             (cnt_6             ),
	.cnt_7             (cnt_7             ),
	.cnt_8             (cnt_8             ),
	.divider_en        (divider_en        ),
	.cent_cnt          (cent_cnt          ),
	.cent_cnt_nxt_block(cent_cnt_nxt_block),
	.divide_by_0       (divide_by_0       ),
	.new_centroid      (new_centroid_in   )
);

//BLOCK 3
convergence_check_block #(
	.tc_mode         (tc_mode         ),
	.rem_mode        (rem_mode        ),
	.accum_width     (accum_width     ),
	.addrWidth       (addrWidth       ),
	.dataWidth       (dataWidth       ),
	.centroid_num    (centroid_num    ),
	.accum_cord_width(accum_cord_width),
	.cordinate_width (cordinate_width ),
	.count_width     (count_width     ),
	.manhatten_width (manhatten_width )
) u_convergence_check_block (
	.clk                     (clk                     ),
	.rst_n                   (rst_n                   ),
	.convergence_reg_en      (convergence_reg_en      ),
	.convergence_regs_reset_n(convergence_regs_reset_n),
	.has_converged           (has_converged           ),
	.converge_res_available  (converge_res_available  ),
	.thresh_hold             (threshold_value         ),
	.old_centroid_reg_1      (old_centroid_reg_1      ),
	.old_centroid_reg_2      (old_centroid_reg_2      ),
	.old_centroid_reg_3      (old_centroid_reg_3      ),
	.old_centroid_reg_4      (old_centroid_reg_4      ),
	.old_centroid_reg_5      (old_centroid_reg_5      ),
	.old_centroid_reg_6      (old_centroid_reg_6      ),
	.old_centroid_reg_7      (old_centroid_reg_7      ),
	.old_centroid_reg_8      (old_centroid_reg_8      ),
	.new_centroid_in         (new_centroid_in         ),
	.cent_num                (cent_cnt_nxt_block      ),
	.divide_by_0             (divide_by_0             ),
	.new_centroid_out        (new_centroid_out        )
);


/*-----------comb logic-------------*/
assign RAMs_out_data_merged[ram_word_len-1:0] = RAM1_data_out[ram_word_len-1:0];
assign RAMs_out_data_merged[dataWidth-1 : ram_word_len]	= RAM2_data_out[dataWidth-ram_word_len-1:0];
assign reg_num = reg_num_wire;
assign Reg_write_data_from_core =Reg_write_data_from_core_wire;

/*-----MUX to manage RAM inputs --------*/
//mux RAM if go =0 -> The algorithm did not start, write to RAM from reg file, RAM inputs from reg file
//mux RAM if go =1 -> The algorithm did start, write to RAM from reg file, RAM inputs from controller

always @(go_signal  or adress2core or data2core or data2core or W_R_RAM_N or CHIP_SEL_RAM_N or RAM_adress_from_controller or web_from_controller or oeb_from_controller or csb_from_controller) begin
	case(go_signal)
		1'b0 : begin //form Reg file to RAM
			RAMs_adress = adress2core;
			RAM1_data_in = data2core[ram_word_len-1:0];
			RAM2_data_in [dataWidth-1-ram_word_len:0]= data2core[dataWidth-1:ram_word_len];
			RAM2_data_in [ram_word_len-1:dataWidth-ram_word_len] =0;
			web = W_R_RAM_N;
			oeb = 1;
			csb = CHIP_SEL_RAM_N;
		end
		1'b1 : begin //from core conteroller to ram
			RAMs_adress=RAM_adress_from_controller;
			RAMs_adress =RAM_adress_from_controller;
			web = web_from_controller;
			oeb = oeb_from_controller;
			csb = csb_from_controller;
		end
	endcase
end

always @(reg_num_wire) begin
	case(reg_num_wire)
		cent_1_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_1;
		cent_2_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_2;
		cent_3_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_3;
		cent_4_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_4;
		cent_5_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_5;
		cent_6_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_6;
		cent_7_reg   		  : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_7;
		cent_8_reg   	      : Reg_write_data_from_core_wire     <= u_convergence_check_block.old_centroid_reg_8;
		default				  :Reg_write_data_from_core_wire      <= 0;
	endcase
	
end
endmodule
