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

module top_tb #(
	synthesis_param   = 34,
	tc_mode           = 1,    //configures two's complement mode in divider
	rem_mode          =1,     //configures modulus mode in divider
	accum_width       = 7*22, // bit width of accumulators,depends on data set size ,data set range and data set dimensions
	addrWidth         = 9,    // bit width of ram address,depends on rams size/data set size
	dataWidth         = 91,   // bit width of data set, in this case, 7 dimensions each with 13 bits: MSB -sign bit,2 integer bits and 10 fractional bits
	centroid_num      =8,     //number of centroids,in this case 8
	log2_cent_num     = 3,    //log of number of centroids
	accum_cord_width  = 22,   // bit width of each accumulator dimension,depends on  data set size ,data set range
	cordinate_width   = 13,   //bit width of each data set dimension , in this case 13 bits: MSB -sign bit,2 integer bits and 10 fractional bits
	count_width       = 10,   //bit width of data points counter,depends on data set size
	manhatten_width   = 16,   //bit width of the sum of all centroid dimensions,depends on data representation,in this case max bit width of sum of 7 nuber with 13 bits: MSB -sign bit,2 integer bits and 10 fractional bits
	log2_of_point_cnt = 9,    //log of data set size
	ram_word_len      = 50,   // in order to store 91 bits long words,two rams of 50 bits wered use, this was a ram constrain from lab manager
	reg_amount        = 8     //amount of registers in reg file
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
	#5 clk = ~clk;  //100 MHz

//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	
	
	//----------------first test-------------------------------//
	
	// pseudo random inputs test - 12 different inputs,two with data in dimensions 2 & 3
	
	initiate_all; //sets all APBS lines,clk and reset to 0. (Resets the DUT)
	
	//write initial values of centroids
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
	
	//configure first address in ram where there will be data
	#10
			write_to_reg_file(first_ram_addr_reg,1);
	//configure last address in ram where there will be data
	#10
			write_to_reg_file(last_ram_addr_reg,10);
	
	//from now,write data points to ram by indirect access in two steps:
	
	//choose which address of RAM  to push data to(in this case ram address 1)
	#10
			write_to_reg_file(RAM_addr_reg,1);
	//write data to the chosen address(in this case write 0x11 to RAM address 1)
	#10
			write_to_reg_file(RAM_data_reg,11);
	
	//write 0x12 to ram address 2
	#10
			write_to_reg_file(RAM_addr_reg,2);
	#10
			
			write_to_reg_file(RAM_data_reg,12);
	//write 0x13 to ram address 3
	#10
			
			write_to_reg_file(RAM_addr_reg,3);
	#10
			
			write_to_reg_file(RAM_data_reg,13);
	#10
			//write 0x14 to ram address 4
			write_to_reg_file(RAM_addr_reg,4);
	#10
			
			write_to_reg_file(RAM_data_reg,14);
	//write 0x15 to ram address 5
	#10
			
			write_to_reg_file(RAM_addr_reg,5);
	#10
			
			write_to_reg_file(RAM_data_reg,15);
	//write 0x16 to ram address 6
	#10
			write_to_reg_file(RAM_addr_reg,6);
	#10
			
			write_to_reg_file(RAM_data_reg,16);
	//write 0x17 to ram address 7
	#10
			
			write_to_reg_file(RAM_addr_reg,7);
	#10
			
			write_to_reg_file(RAM_data_reg,17);
	//write 0x18 to ram address 8
	#10
			write_to_reg_file(RAM_addr_reg,8);
	#10
			
			write_to_reg_file(RAM_data_reg,18);
	//write (0,..,0x07,0x00) to ram address 9
	#10
			write_to_reg_file(RAM_addr_reg,9);
	#10
			
			write_to_reg_file(RAM_data_reg,{65'd0,13'd7,13'b0});
	//write (0,..,0x17,0x00,0x07) to ram address 9
	#10
			write_to_reg_file(RAM_addr_reg,10);
	#10
			
			write_to_reg_file(RAM_data_reg,{52'd0,13'd17,13'd0,13'd7});
	//send go to core(start algorithm)
	write_to_reg_file(go_reg,1);
	#10
			
			//wait for algorithm to end,i.e,wait for interrupt signal to rise
			
			@ (posedge interupt);
	
	#50
			
			
			//------------------second test --------------------------------------------//
			//do nothing test -> initial centroids = finals centroids
			
			
			initiate_all; //sets all APBS lines,clk and reset to 0. (Resets the DUT)
	
	//write initial values of centroids
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
	
	//configure first address in ram where there will be data
	#10
			write_to_reg_file(first_ram_addr_reg,1);
	//configure last address in ram where there will be data
	#10
			write_to_reg_file(last_ram_addr_reg,8);
	
	//from now,write data points to ram by indirect access in two steps:
	
	//choose which address of RAM  to push data to(in this case ram address 1)
	#10
			write_to_reg_file(RAM_addr_reg,1);
	//write data to the chosen address(in this case write 0x1 to RAM address 1)
	#10
			write_to_reg_file(RAM_data_reg,1);
	
	//write 0x2 to ram address 2
	#10
			write_to_reg_file(RAM_addr_reg,2);
	#10
			
			write_to_reg_file(RAM_data_reg,2);
	//write 0x3 to ram address 3
	#10
			
			write_to_reg_file(RAM_addr_reg,3);
	#10
			
			write_to_reg_file(RAM_data_reg,3);
	#10
			//write 0x4 to ram address 4
			write_to_reg_file(RAM_addr_reg,4);
	#10
			
			write_to_reg_file(RAM_data_reg,4);
	//write 0x5 to ram address 5
	#10
			
			write_to_reg_file(RAM_addr_reg,5);
	#10
			
			write_to_reg_file(RAM_data_reg,5);
	//write 0x6 to ram address 6
	#10
			write_to_reg_file(RAM_addr_reg,6);
	#10
			
			write_to_reg_file(RAM_data_reg,6);
	//write 0x7 to ram address 7
	#10
			
			write_to_reg_file(RAM_addr_reg,7);
	#10
			
			write_to_reg_file(RAM_data_reg,7);
	//write 0x8 to ram address 8
	#10
			write_to_reg_file(RAM_addr_reg,8);
	#10
			
			write_to_reg_file(RAM_data_reg,8);
	
	//send go to core(start algorithm)
	write_to_reg_file(go_reg,1);
	#10
			
			
			//wait for algorithm to end,i.e,wait for interrupt signal to rise
			
			@ (posedge interupt);
	
	#20 $finish;
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



endmodule : top_tb