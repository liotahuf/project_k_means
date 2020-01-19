/*------------------------------------------------------------------------------
 * File          : flop_test.sv
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





module flop_test #(
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
) ();

//-----------------------------------------
//			Registers & Wires
//-----------------------------------------

reg clk;
reg rst_n;

/*--------------RegFile--------------*/

enum logic [7:0] { internal_status_reg,go_reg,cent_1_reg,cent_2_reg,cent_3_reg,cent_4_reg,cent_5_reg,cent_6_reg,cent_7_reg,cent_8_reg,
	               RAM_addr_reg,RAM_data_reg,first_ram_addr_reg,last_ram_addr_reg} register_num;

//APB to RegFile
reg [addrWidth-1:0] paddr;
reg pwrite;
reg psel;
reg penable;
reg [dataWidth-1:0] pwdata;

//core to RegFile
wire [dataWidth-1:0] Reg_write_data_from_core;

//RegFile to APB
//outs to APB
reg [dataWidth-1:0] prdata;
reg pready;

//RegFile to kmeanscore's - to RAM
wire [91 - 1:0] data2core;
wire [addrWidth - 1:0] adress2core;
wire W_R_RAM_N;
wire OUT_EN_RAM_N;
wire CHIP_SEL_RAM_N;

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
wire go_core;
wire [addrWidth-1:0]first_ram_adress;
wire [addrWidth-1:0]last_ram_addr;
wire [reg_amount-1:0]reg_num;
wire reg_write;
wire interrupt;
wire go_signal;



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

wire [dataWidth-1:0] centroid_reg_1;
wire [dataWidth-1:0] centroid_reg_2;
wire [dataWidth-1:0] centroid_reg_3;
wire [dataWidth-1:0] centroid_reg_4;
wire [dataWidth-1:0] centroid_reg_5;
wire [dataWidth-1:0] centroid_reg_6;
wire [dataWidth-1:0] centroid_reg_7;
wire [dataWidth-1:0] centroid_reg_8;

//garbage end


/*-------------instantiations---------------------------------------*/
RegFile registerFile (
	.clk                  (clk                     ),
	.rst_n                (rst_n                   ),
	.paddr                (paddr                   ),
	.pwrite               (pwrite                  ),
	.psel                 (psel                    ),
	.penable              (penable                 ),
	.pwdata               (pwdata                  ),
	.prdata               (prdata                  ),
	.pready               (pready                  ),
	.reg_num              (reg_num                 ),
	.reg_write            (reg_write               ),
	.reg_write_data       (Reg_write_data_from_core), //TODO : connect this wire later
	.interupt             (interrupt               ),
	.go_core              (go_core                 ),
	.w_r_ram_n            (W_R_RAM_N               ),
	.data2core            (data2core               ),
	.address2core         (adress2core             ),
	.out_en_ram_n         (OUT_EN_RAM_N            ),
	.chip_select_ram_n    (CHIP_SEL_RAM_N          ),
	.first_ram_address_out(first_ram_adress        ),
	.last_ram_address_out (last_ram_addr           ),
	.threshold_value      (                        )
);


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
	.first_ram_addr           (first_ram_adress          ),
	.last_ram_addr            (last_ram_addr             ),
	//out to REGFILE
	.reg_write                (reg_write                 ),
	.reg_num                  (reg_num                   ),
	.interupt                 (interrupt                 ),
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
	.data_to_regfile   (data_to_regfile     ), //not for now
	
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
	.centroid_reg_1    (centroid_reg_1      ),
	.centroid_reg_2    (centroid_reg_2      ),
	.centroid_reg_3    (centroid_reg_3      ),
	.centroid_reg_4    (centroid_reg_4      ),
	.centroid_reg_5    (centroid_reg_5      ),
	.centroid_reg_6    (centroid_reg_6      ),
	.centroid_reg_7    (centroid_reg_7      ),
	.centroid_reg_8    (centroid_reg_8      ),
	//input
	.cent_cnt          (cent_cnt            ),
	.new_centroid      (new_centroid        )
);


/*-----------comb logic-------------*/
assign RAMs_out_data_merged[ram_word_len-1:0] = RAM1_data_out[ram_word_len-1:0];
assign RAMs_out_data_merged[dataWidth-1 : ram_word_len]	= RAM2_data_out[dataWidth-ram_word_len-1:0];


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

//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;

//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	
	initiate_all;
	
	
	#10
			write_to_reg_file(cent_1_reg,1);
	#10
			write_to_reg_file(cent_2_reg,2);
	#10
			write_to_reg_file(cent_3_reg,3);
	#10
			write_to_reg_file(cent_4_reg,4);
	#10
			write_to_reg_file(cent_5_reg,5);
	#10
			write_to_reg_file(cent_6_reg,6);
	#10
			write_to_reg_file(cent_7_reg,7);
	#10
			write_to_reg_file(cent_8_reg,8);
	
	//choose which adress of RAM  to push data to
	#10
			write_to_reg_file(first_ram_addr_reg,1);
	
	#10
			write_to_reg_file(last_ram_addr_reg,8);
	//write 6 to ram dress 1
	#10
			write_to_reg_file(RAM_addr_reg,1);
	#10
			
			write_to_reg_file(RAM_data_reg,11);
	
	//write 12 to ram adress 2
	#10
			write_to_reg_file(RAM_addr_reg,2);
	#10
			//@(posedge clk);
			write_to_reg_file(RAM_data_reg,12);
	#10//write 7 to ram adress 3
			
			write_to_reg_file(RAM_addr_reg,3);
	#10
			
			write_to_reg_file(RAM_data_reg,13);
	#10
			//write 8 to ram addr 4
			write_to_reg_file(RAM_addr_reg,4);
	#10
			
			write_to_reg_file(RAM_data_reg,14);
	#10//write 7 to ram adress 5
			
			write_to_reg_file(RAM_addr_reg,5);
	#10
			
			write_to_reg_file(RAM_data_reg,15);
	
	#10//write 8 to ram adress 6
			write_to_reg_file(RAM_addr_reg,6);
	#10
			
			write_to_reg_file(RAM_data_reg,16);
	#10//write 7 to ram adress 7
			
			write_to_reg_file(RAM_addr_reg,7);
	#10
			
			write_to_reg_file(RAM_data_reg,17);
	
	#10//write 8 to ram adress 8
			write_to_reg_file(RAM_addr_reg,8);
	#10
			
			write_to_reg_file(RAM_data_reg,18);
	#10
	//go
	write_to_reg_file(go_reg,1);
	#10
			
			#1000 $finish;
end



task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		paddr = 1'b0;
		pwrite = 1'b0;
		psel = 1'b0;
		penable = 1'b0;
		
		
		
		
		#5 rst_n = 1'b1;
	end
endtask

task write_to_reg_file;
	input [8-1:0] adress;
	input [dataWidth-1:0] data;
	begin
		paddr = adress;
		pwdata= data;
		pwrite = 1;
		psel=1;
		#10
				penable=1;
		#10
				psel = 1'b0;
		penable = 1'b0;
	end
endtask

task read_from_regfile;
	input [addrWidth-1:0] adress;
	begin
		paddr = adress;
		//pwdata= 8'b00000001;
		pwrite = 0;//read
		psel=1;
		#10
				penable=1;
		#10
				psel = 1'b0;
		penable = 1'b0;
	end
endtask

/*task read_from_RAM;
input [`numAddr-1:0] Addr;
begin
RAM_adress_from_controller=Addr;
web_from_controller = 1;
oeb_from_controller=0;
csb_from_controller =0;
#10
web_from_controller = 0;
oeb_from_controller=0;
csb_from_controller =1;

end
endtask*/




endmodule : flop_test