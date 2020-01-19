/*------------------------------------------------------------------------------
 * File          : TestBench.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   : Test Bench for k means top. Checks for APB writes and 
 * 				   reads of internal registers of top
 * 				   Including reg file and the k means core as a inside Unit
 *------------------------------------------------------------------------------*/

module TestBench 
#(
addrWidth = 8,
dataWidth = 91
) 
();

//-----------------------------------------
//			Registers & Wires
//-----------------------------------------


	reg clk;
	reg rst_n;
	reg  [addrWidth-1:0] paddr;
	reg pwrite;
	reg psel;
	reg penable;
	reg [dataWidth-1:0] pwdata;
	reg [dataWidth-1:0] prdata;
	reg pready;

k_means_top k_means_top(
		.clk(clk),
		.rst_n(rst_n),
		.paddr(paddr),
		.pwrite(pwrite),
		.psel(psel),
		.penable(penable),
		.pwdata(pwdata),
		.prdata(prdata),
		.pready(pready));



//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	initiate_all;
	#10
	@(posedge clk);
	write_to_reg_file(5,1);
	#10
	@(posedge clk);
	read_from_regfile(5);
	#10
	@(posedge clk);
	write_to_reg_file(2,10);
	#30
	@(posedge clk);
	read_from_regfile(2);
	#10
	@(posedge clk);
	write_to_reg_file(5,15);
	#10
	@(posedge clk);
	read_from_regfile(5);
	#100 $finish;
end


//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;
 


task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		paddr = 1'b0;
		pwrite = 1'b0;
		psel = 1'b0;
		penable = 1'b0;
		
		
		#2.5 rst_n = 1'b1;
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

task clean;
	begin
//		paddr = 1'b0;
//		pwrite = 1'b0;
		psel = 1'b0;
		penable = 1'b0;
	end
endtask


endmodule : TestBench