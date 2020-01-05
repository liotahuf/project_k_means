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
	input                  clk,
	input                  rst_n,
	//IF with REGFILE
	input  [dataWidth-1:0] ram_address,
	input  [dataWidth-1:0] ram_data,
	input                  w_r_ram,
	input                  go,
	input  [addrWidth-1:0] first_ram_address,
	input  [addrWidth-1:0] last_ram_address,
	//IF with k-means-core
	input                  centroid_after_converge
	input  [2:0]           centroid_cnt,
	///
	output [addrWidth-1:0] reg_num,
	output                 reg_w_r,
	output [dataWidth-1:0] reg_write_data,
	output                 interuptt
);

/*-----REGS & WIRES------*/

//controller IF with ram1 and ram2
wire [dataWidth-1:0] RAMs_adress;
wire web;
wire oeb;
wire csb;

//TODO:add mux



//RAMs
spram512x50_cb RAM_1 (
	.A  (RAMs_adress),
	.CEB(clk        ),
	.WEB(web        ),
	.OEB(oeb        ),
	.CSB(csb        ),
	.I  (I          ),
	.O  (O          )
);

spram512x50_cb RAM_2 (
	.A  (RAMs_adress),
	.CEB(clk        ),
	.WEB(WEB        ),
	.OEB(OEB        ),
	.CSB(CSB        ),
	.I  (I          ),
	.O  (O          )
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
	.convergence_reg_en      (convergence_reg_en      ),
	.convergence_regs_reset_n(convergence_regs_reset_n),
	.has_converged           (has_converged           ),
	.converge_res_available  (converge_res_available  ),
	.thresh_hold             (thresh_hold             ),
	.old_centroid_reg_1      (old_centroid_reg_1      ),
	.old_centroid_reg_2      (old_centroid_reg_2      ),
	.old_centroid_reg_3      (old_centroid_reg_3      ),
	.old_centroid_reg_4      (old_centroid_reg_4      ),
	.old_centroid_reg_5      (old_centroid_reg_5      ),
	.old_centroid_reg_6      (old_centroid_reg_6      ),
	.old_centroid_reg_7      (old_centroid_reg_7      ),
	.old_centroid_reg_8      (old_centroid_reg_8      ),
	.new_centroid_in         (new_centroid_in         ),
	.cent_num                (cent_num                ),
	.new_centroid_out        (new_centroid_out        )
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
	.ram_addr                 (RAMs_adress                                       ),
	.wr_en_n                  (web                                               ),
	.output_en_n              (oeb                                               ),
	.chip_select_n            (csb                                               ),
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
	.converge_res_available   (u_convergence_check_block.converge_res_available  )
);







//TODO: add connection of registers from classification block to regfile of the centroids when converged



//TODO : add mux to choose for RAM inputs/outputs - CORE or REGFILE
endmodule : k_means_core
