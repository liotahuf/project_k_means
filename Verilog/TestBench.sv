/*------------------------------------------------------------------------------
 * File          : TestBench.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   :Test Bench Cluster
 * 	including reg file and the k means core as a inside Unit
 *------------------------------------------------------------------------------*/

module TestBench #(
addrWidth = 8,
dataWidth = 91) ();

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

k_means_top k_means_top(.clk(clk),.rst_n(rst_n),.paddr(paddr),.pwrite(pwrite),.psel(psel),.penable(penable),
						.pwdata(pwdata),.prdata(prdata),.pready(pready));



//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	initiate_all;
	#100
	@(posedge clk);
	write_to_reg_file;
	#100
	
	@(posedge clk);
	write_to_reg_file;
end


//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#2.5 clk = ~clk;
 


task initiate_all;
	begin
		clk = 1'b0;
		rst_n = 1'b0;
		paddr = 1'b0;
		pwrite = 1'b0;
		psel = 1'b0;
		penable = 1'b0;
		
		
		#2.5 rst_n = 1'b1;
	end
endtask

task write_to_reg_file;
	begin
		paddr = 8'b00000001;
		pwdata= 8'b00000001;
		pwrite = 1;
		psel=1;
		#5
		penable=1;		
	end
endtask

endmodule : TestBench