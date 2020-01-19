/*------------------------------------------------------------------------------
 * File          : k_means_core.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Sep 25, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module k_means_core #(
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
	reg_amount        = 4
) (
	input                        clk,
	input                        rst_n,
	//IF with REGFILE
	input  [dataWidth-1:0]       ram_address_from_reg_file,
	input  [dataWidth-1:0]       ram_data_from_reg_file,
	input                        w_r_ram,
	input                        chip_select_ram_n,
	input                        go,
	input  [addrWidth-1:0]       first_ram_address,
	input  [addrWidth-1:0]       last_ram_address,
	input  [manhatten_width-1:0] threshold_value,
	
	///
	output [addrWidth-1:0]       reg_num,
	output                       reg_w_r,
	output [dataWidth-1:0]       reg_write_data,
	output                       interuptt
);

/*-----REGS & WIRES------*/

//controller IF with ram1 and ram2
reg [addrWidth-1:0] RAM1_adress;
reg [addrWidth-1:0] RAM2_adress;
wire [ram_word_len-1:0] RAM1_data;
wire [ram_word_len-1:0] RAM2_data;
wire [dataWidth-1:0] RAM_data_merged;

wire [addrWidth-1:0] RAM_adress_from_controller;
wire web_from_controller;
wire oeb_from_controller;
wire csb_from_controller;

reg web;
reg oeb;
reg csb;
wire go_signal;


/*-----MUX to manage RAM inputs --------*/
//mux RAM if go =0 -> The algorithm did not start, write to RAM from reg file, RAM inputs from reg file
//mux RAM if go =1 -> The algorithm did start, write to RAM from reg file, RAM inputs from controller

always @(go_signal) begin
	case(go_signal)
		1'b0 : begin //form Reg file to RAM
			RAM1_adress=ram_address_from_reg_file;
			RAM2_adress =ram_address_from_reg_file;
			web = w_r_ram;
			oeb = 1;
			csb = chip_select_ram_n;
		end
		1'b1 : begin //from core conteroller to ram
			RAM1_adress=RAM_adress_from_controller;
			RAM2_adress =RAM_adress_from_controller;
			web = web_from_controller;
			oeb = oeb_from_controller;
			csb = csb_from_controller;
			
		end
	endcase
end

// join the two RAMs output into one of size dat_width
assign RAM_data_merged[ram_word_len-1:0] =RAM1_data[ram_word_len-1:0];
assign RAM_data_merged[dataWidth-1:ram_word_len] =RAM2_data[dataWidth-1-ram_word_len:0];



//RAMs
spram512x50_cb RAM_1 (
	.A  (RAMs_adress),
	.CEB(clk        ),
	.WEB(web        ),
	.OEB(oeb        ),
	.CSB(csb        ),
	.I  (I          ),
	.O  (RAM1_data  )
);

spram512x50_cb RAM_2 (
	.A  (RAMs_adress),
	.CEB(clk        ),
	.WEB(WEB        ),
	.OEB(OEB        ),
	.CSB(CSB        ),
	.I  (I          ),
	.O  (RAM2_data  )
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
	.clk               (clk               ),
	.rst_n             (rst_n             ),
	.data_from_ram     (data_from_ram     ),
	.ram_input_reg_en  (ram_input_reg_en  ),
	.centroid_en       (centroid_en       ),
	.accumulators_en   (accumulators_en   ),
	.pipe3_regs_reset_n(pipe3_regs_reset_n),
	.first_iteration   (first_iteration   ),
	.data_from_regfile (data_from_regfile ),
	.data_to_regfile   (data_to_regfile   ),
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
	.centroid_reg_1    (centroid_reg_1    ),
	.centroid_reg_2    (centroid_reg_2    ),
	.centroid_reg_3    (centroid_reg_3    ),
	.centroid_reg_4    (centroid_reg_4    ),
	.centroid_reg_5    (centroid_reg_5    ),
	.centroid_reg_6    (centroid_reg_6    ),
	.centroid_reg_7    (centroid_reg_7    ),
	.centroid_reg_8    (centroid_reg_8    ),
	.cent_cnt          (cent_cnt          ),
	.new_centroid      (new_centroid      )
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
	.new_centroid      (new_centroid      )
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
	.convergence_reg_en      (u_controller.convergence_reg_en      ),
	.convergence_regs_reset_n(u_controller.convergence_regs_reset_n),
	.has_converged           (u_controller.has_converged           ),
	.converge_res_available  (u_controller.converge_res_available  ),
	.thresh_hold             (threshold_value         ),
	.old_centroid_reg_1      (old_centroid_reg_1      ),
	.old_centroid_reg_2      (old_centroid_reg_2      ),
	.old_centroid_reg_3      (old_centroid_reg_3      ),
	.old_centroid_reg_4      (old_centroid_reg_4      ),
	.old_centroid_reg_5      (old_centroid_reg_5      ),
	.old_centroid_reg_6      (old_centroid_reg_6      ),
	.old_centroid_reg_7      (old_centroid_reg_7      ),
	.old_centroid_reg_8      (old_centroid_reg_8      ),
	.new_centroid_in         (u_new_means_calculation_block.new_centroid         ),
	.cent_num                (u_new_means_calculation_block.cent_cnt                ),
	.new_centroid_out        (u_classification_block.new_centroid       )
);


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
	.clk                      (clk                                               ),
	.rst_n                    (rst_n                                             ),
	.go                       (go                                                ),
	.first_ram_addr           (first_ram_address                                 ),
	.last_ram_addr            (last_ram_address                                  ),
	.reg_num                  (reg_num                                           ),
	.reg_write                (reg_w_r                                           ),
	.ram_addr                 (RAM_adress_from_controller                        ),
	.wr_en_n                  (web_from_controller                               ),
	.output_en_n              (oeb_from_controller                               ),
	.chip_select_n            (csb_from_controller                               ),
	.ram_input_reg_en         (u_classification_block.ram_input_reg_en           ),
	.centroid_en              (u_classification_block.centroid_en                ),
	.accumulators_en          (u_classification_block.accumulators_en            ),
	.pipe3_regs_reset_n       (u_classification_block.pipe3_regs_reset_n         ),
	.first_iteration          (u_classification_block.first_iteration            ),
	.divider_en               (u_new_means_calculation_block.divider_en          ),
	.cent_cnt                 (u_new_means_calculation_block.cent_cnt            ),
	.wr_cnvrg_to_calc_cent_num(/*TODO - maybe rmv this signal*/                  ),
	.convergence_reg_en       (u_convergence_check_block.convergence_reg_en      ),
	.convergence_regs_reset_n (u_convergence_check_block.convergence_regs_reset_n),
	.has_converged            (u_convergence_check_block.has_converged           ),
	.converge_res_available   (u_convergence_check_block.converge_res_available  ),
	.interupt                 (                                                  ),
	.go_signal                (go_signal                                         )
);

RegFile #(
	.addrWidth      (addrWidth      ),
	.dataWidth      (dataWidth      ),
	.reg_amount     (reg_amount     ),
	.manhatten_width(manhatten_width)
) u_RegFile (
	.clk                  (clk                  ),
	.rst_n                (rst_n                ),
	.paddr                (paddr                ),
	.pwrite               (pwrite               ),
	.psel                 (psel                 ),
	.penable              (penable              ),
	.pwdata               (pwdata               ),
	.prdata               (prdata               ),
	.pready               (pready               ),
	.interupt             (interupt             ),
	.reg_num              (reg_num              ),
	.reg_write            (reg_write            ),
	.reg_write_data       (reg_write_data       ),
	.data2core            (data2core            ),
	.address2core         (address2core         ),
	.go_core              (go_core              ),
	.w_r_ram_n            (w_r_ram_n            ),
	.out_en_ram_n         (out_en_ram_n         ),
	.chip_select_ram_n    (chip_select_ram_n    ),
	.first_ram_address_out(first_ram_address_out),
	.last_ram_address_out (last_ram_address_out ),
	.threshold_value      (threshold_value      )
);






//TODO: add connection of registers from classification block to regfile of the centroids when converged



//TODO : add mux to choose for RAM inputs/outputs - CORE or REGFILE
endmodule : k_means_core
