/*------------------------------------------------------------------------------
 * File          : RegFileTB.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 23, 2019
 * Description   : Test bench for Reg file,simulate file interface with APB master and with core
 *------------------------------------------------------------------------------*/

module RegFileTB #(addrWidth = 8, dataWidth = 91) ();

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


enum logic [7:0] { internal_status_reg,go_reg,cent_1_reg,cent_2_reg,cent_3_reg,cent_4_reg,cent_5_reg,cent_6_reg,cent_7_reg,cent_8_reg,
	RAM_addr_reg,RAM_data_reg,first_ram_addr_reg,last_ram_addr_reg} register_num;

wire [91 - 1:0] data2core;
wire [91 - 1:0] adress2core;
wire W_R_RAM;
RegFile registerFile (
	.clk    (clk    ),
	.rst_n  (rst_n  ),
	.paddr  (paddr  ),
	.pwrite (pwrite ),
	.psel   (psel   ),
	.penable(penable),
	.pwdata (pwdata ),
	.prdata (prdata ),
	.pready (pready ),
	.reg_num(Reg_num),
	.reg_write(Reg_w_r_from_core),
	.reg_write_data(Reg_write_data_from_core),
	.interupt(interupt),
	.go_core(go),
	.w_r_ram(W_R_RAM),
	.data2core(data2core),
	.address2core(adress2core));


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
	//#10
	#10
	write_to_reg_file(RAM_addr_reg,1);
	#10
	//@(posedge clk);
	write_to_reg_file(RAM_data_reg,6);
	
	//#10
	@(posedge clk);
	write_to_reg_file(go_reg,1);
	
	//#10
	@(posedge clk);
	write_to_reg_file(RAM_addr_reg,1);
	//#10
	@(posedge clk);
	write_to_reg_file(RAM_data_reg,7);
	
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




endmodule : RegFileTB