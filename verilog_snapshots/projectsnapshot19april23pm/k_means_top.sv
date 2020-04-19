/*------------------------------------------------------------------------------
 * File          : k_means_top.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module k_means_top #(
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
	//APB signals
	input                  clk,
	input                  rst_n,
	input  [addrWidth-1:0] paddr,
	input                  pwrite,
	input                  psel,
	input                  penable,
	input  [dataWidth-1:0] pwdata,
	output [dataWidth-1:0] prdata,
	output                 pready,
	output                 interupt
	
	
	
);





//wire  [dataWidth-1:0] Reg_read_data1;
//wire  [dataWidth-1:0] Reg_read_data2;


//from reg file to core
wire [dataWidth-1:0] data2core;
wire [dataWidth-1:0] address2core;
wire go_core;
wire W_R_RAM_N;
wire out_en_ram_n;
wire chip_select_ram_n;
wire [addrWidth-1:0]first_ram_address;
wire [addrWidth-1:0]last_ram_address;
wire [manhatten_width-1:0]threshold_value;



//from core to reg file

wire                 reg_w_r;
wire  [dataWidth-1:0] Reg_write_data_from_core;
wire [reg_amount-1:0 ] reg_num;



// ----------------------------------------------------------------------
//                   Instantiation
// ----------------------------------------------------------------------

RegFile #(
	.addrWidth      (addrWidth      ),
	.dataWidth      (dataWidth      ),
	.reg_amount     (reg_amount     ),
	.manhatten_width(manhatten_width)
) u_RegFile (
	.clk                  (clk                     ),
	.rst_n                (rst_n                   ),
	.paddr                (paddr                   ),
	.pwrite               (pwrite                  ),
	.psel                 (psel                    ),
	.penable              (penable                 ),
	.pwdata               (pwdata                  ),
	.prdata               (prdata                  ),
	.pready               (pready                  ),
	.interupt             (interupt                ),
	.reg_num              (reg_num                 ),
	.reg_write            (reg_w_r                 ),
	.reg_write_data       (Reg_write_data_from_core),
	.data2core            (data2core               ),
	.address2core         (address2core            ),
	.go_core              (go_core                 ),
	.w_r_ram_n            (W_R_RAM_N               ),
	.out_en_ram_n         (out_en_ram_n            ),
	.chip_select_ram_n    (chip_select_ram_n       ),
	.first_ram_address_out(first_ram_address       ),
	.last_ram_address_out (last_ram_address        ),
	.threshold_value      (threshold_value         )
);

k_means_core #(
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
) u_k_means_core (
	.clk                     (clk                     ),
	.rst_n                   (rst_n                   ),
	.adress2core             (address2core            ),
	.data2core               (data2core               ),
	.go_core                 (go_core                 ),
	.first_ram_address       (first_ram_address       ),
	.last_ram_address        (last_ram_address        ),
	.threshold_value         (threshold_value         ),
	.W_R_RAM_N               (W_R_RAM_N               ),
	.CHIP_SEL_RAM_N          (chip_select_ram_n       ),
	.reg_num                 (reg_num                 ),
	.reg_w_r                 (reg_w_r                 ),
	.Reg_write_data_from_core(Reg_write_data_from_core),
	.interupt                (interupt                )
);

















endmodule