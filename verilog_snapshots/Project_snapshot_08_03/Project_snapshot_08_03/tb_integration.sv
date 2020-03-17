/*------------------------------------------------------------------------------
 * File          : RegFileTB.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 23, 2019
 * Description   : Test bench for Reg file,simulate file interface with APB master and with core
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

module tb_integration #(
	addrWidth    = 9,
	dataWidth    = 91,
	reg_amount   =4,
	ram_word_len = 50
) ();

//-----------------------------------------
//			Registers & Wires
//-----------------------------------------

/* APB master signals*/
reg clk;
reg rst_n;
reg  [addrWidth-1:0] paddr;
reg pwrite;
reg psel;
reg penable;
reg [dataWidth-1:0] pwdata;
reg [dataWidth-1:0] prdata;
reg pready;
reg [addrWidth-1:0] RAM1_adress;
reg [addrWidth-1:0] RAM2_adress;
//reg go_signal;



enum logic [7:0] { internal_status_reg,go_reg,cent_1_reg,cent_2_reg,cent_3_reg,cent_4_reg,cent_5_reg,cent_6_reg,cent_7_reg,cent_8_reg,
	               RAM_addr_reg,RAM_data_reg,first_ram_addr_reg,last_ram_addr_reg} register_num;

wire [91 - 1:0] data2core;
wire [addrWidth - 1:0] adress2core;
wire W_R_RAM_N;
wire OUT_EN_RAM_N;
wire CHIP_SEL_RAM_N;
//RAM's I/O
wire [ram_word_len-1:0] RAM1_data_out;
wire [ram_word_len-1:0] RAM2_data_out;
//wire [ram_word_len-1:0] RAM1_data_in;
//wire [ram_word_len-1:0] RAM2_data_in;
wire [dataWidth-1:0] RAM_data_merged;


reg [`numAddr-1:0] RAMs_adress;
reg [`numOut-1:0] RAM1_data_in;
reg [`numOut-1:0] RAM2_data_in;

reg[addrWidth-1:0] RAM_adress_from_controller;
reg web_from_controller;
reg oeb_from_controller;
reg csb_from_controller;
//wires from controller to regfile
wire go;
/*wire first_ram_adress;
wire last_ram_addr;
wire reg_num;
wire reg_write;
wire interrupt;
wire go_signal;*/

// wires out from controller to core(not used yet)
wire ram_input_reg_en;

wire centroid_en ;
wire accumulators_en;
wire pipe3_regs_reset_n;
wire first_iteration ;
wire divider_en;
wire cent_cnt;
wire wr_cnvrg_to_calc_cent_num;
wire convergence_reg_en;
wire convergence_regs_reset_n;
wire has_converged;
wire converge_res_available;

reg web;
reg oeb;
reg csb;

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
	.reg_write_data       (Reg_write_data_from_core),
	.interupt             (interrupt               ),
	.go_core              (go                      ),
	.w_r_ram_n            (W_R_RAM_N               ),
	.data2core            (data2core               ),
	.address2core         (adress2core             ),
	.out_en_ram_n         (OUT_EN_RAM_N            ),
	.chip_select_ram_n    (CHIP_SEL_RAM_N          ),
	.first_ram_address_out(first_ram_adress        ),
	.last_ram_address_out (                        ),
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

/**----------Controller instantiation---------*/

/*controller #(
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
.reg_amount       (reg_amount       )last_ram_addr_reg
) u_controller (
.clk                      (clk                       ),
.rst_n                    (rst_n                     ),
.go                       (go                        ),
.first_ram_addr           (first_ram_adress          ),
.last_ram_addr            (last_ram_addr             ),
.reg_num                  (reg_num                   ),
.reg_write                (reg_write                 ),
.interupt                 (interupt                  ),
.go_signal                (go_signal                 ),
.ram_addr                 (RAM_adress_from_controller),
.wr_en_n                  (web_from_controller       ),
.output_en_n              (oeb_from_controller       ),
.chip_select_n            (csb_from_controller       ),
.ram_input_reg_en         (ram_input_reg_en          ),
.centroid_en              (centroid_en               ),
.accumulators_en          (accumulators_en           ),
.pipe3_regs_reset_n       (pipe3_regs_reset_n        ),
.first_iteration          (first_iteration           ),
.divider_en               (divider_en                ),
.cent_cnt                 (cent_cnt                  ),
.wr_cnvrg_to_calc_cent_num(wr_cnvrg_to_calc_cent_num ),
.convergence_reg_en       (convergence_reg_en        ),
.convergence_regs_reset_n (convergence_regs_reset_n  ),
.has_converged            (has_converged             ),
.converge_res_available   (converge_res_available    )
);

 */last_ram_addr_reg
/*-----------comb logic-------------*/
assign RAM_data_merged[ram_word_len-1:0] = RAM1_data_out[ram_word_len-1:0];
assign RAM_data_merged[dataWidth-1 : ram_word_len]	= RAM2_data_out[dataWidth-ram_word_len-1:0];


/*-----MUX to manage RAM inputs --------*/
//mux RAM if go =0 -> The algorithm did not start, write to RAM from reg file, RAM inputs from reg file
//mux RAM if go =1 -> The algorithm did start, write to RAM from reg file, RAM inputs from controller

always @(go_signal  or posedge clk) begin
	case(go_signal)
		1'b0 : begin //form Reg file to RAM
			RAMs_adress = adress2core;
			RAM1_data_in =data2core[ram_word_len-1:0];
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
	
	//choose which adress of RAM  to push data to
	#10
			write_to_reg_file(first_ram_addr_reg,1);
	
	#10
			write_to_reg_file(last_ram_addr_reg,3)
			//write 6 to ram dress 1
			#10
			write_to_reg_file(RAM_addr_reg,1);
	#10
			
			write_to_reg_file(RAM_data_reg,6);
	
	//write 12 to ram adress 2
	#10
			write_to_reg_file(RAM_addr_reg,2);
	#10
			//@(posedge clk);
			write_to_reg_file(RAM_data_reg,12);
	#10//write 7 to ram adress 3
			
			write_to_reg_file(RAM_addr_reg,3);
	#10
			
			write_to_reg_file(RAM_data_reg,7);
	
	//go
	write_to_reg_file(go_reg,1);
	#10
			
			
			/*
			read_from_RAM(2);
			#10
			read_from_RAM(1);
			
			#10
			write_to_reg_file(RAM_addr_reg,1);
			#10
			
			write_to_reg_file(RAM_data_reg,7);*/
			
			#100 $finish;
end



task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		paddr = 1'b0;
		pwrite = 1'b0;
		psel = 1'b0;
		penable = 1'b0;
		go_signal =1'b0;
		
		RAM_adress_from_controller =0;
		web_from_controller = 0;
		oeb_from_controller=0;
		csb_from_controller =1;
		
		#5 rst_n = 1'b1;
	end
endtask

task write_to_reg_file;
	input [addrWidth-1:0] adress;
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

task read_from_RAM;
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
endtask




endmodule : tb_integration