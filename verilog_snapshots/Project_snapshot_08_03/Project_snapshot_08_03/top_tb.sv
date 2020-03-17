/*------------------------------------------------------------------------------
 * File          : top_tb.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Mar 8, 2020
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

module top_tb 

#(
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
	reg [dataWidth-1:0] Reg_write_data_from_core;

	//RegFile to APB
	//outs to APB
	reg [dataWidth-1:0] prdata;
	reg pready;
	reg interupt;
	


	


	/*-------------instantiations---------------------------------------*/
	
	k_means_top #(
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
	) u_k_means_top (
		.clk     (clk     ),
		.rst_n   (rst_n   ),
		.paddr   (paddr   ),
		.pwrite  (pwrite  ),
		.psel    (psel    ),
		.penable (penable ),
		.pwdata  (pwdata  ),
		.prdata  (prdata  ),
		.pready  (pready  ),
		.interupt(interupt)
	);

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
				write_to_reg_file(last_ram_addr_reg,10);
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
				write_to_reg_file(RAM_addr_reg,9);
		#10
				
				write_to_reg_file(RAM_data_reg,{65'd0,13'd7,13'b0});
		#10
				write_to_reg_file(RAM_addr_reg,10);
		#10
				
				write_to_reg_file(RAM_data_reg,{52'd0,13'd17,13'd0,13'd7});
		//go
		write_to_reg_file(go_reg,1);
		#10
				
				#2000 $finish;
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

endmodule : top_tb