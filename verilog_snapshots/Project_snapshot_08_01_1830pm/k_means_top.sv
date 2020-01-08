/*------------------------------------------------------------------------------
 * File          : k_means_top.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module k_means_top
#(
  addrWidth = 8,
  dataWidth = 91
)
(
	//APB signals
  input                        clk,
  input                        rst_n,
  input        [addrWidth-1:0] paddr,
  input                        pwrite,
  input                        psel,
  input                        penable,
  input        [dataWidth-1:0] pwdata,
  output 	   [dataWidth-1:0] prdata,
  output     				   pready
  
 
  
);

	
	
	
	
	//wire  [dataWidth-1:0] Reg_read_data1;
	//wire  [dataWidth-1:0] Reg_read_data2;
	wire   			   	  go;
	wire				  interupt;
	wire                  W_R_RAM;
	wire  [addrWidth-1:0] Reg_num;
	wire                  Reg_w_r_from_core;
	wire  [dataWidth-1:0] Reg_write_data_from_core;
	
	wire  [dataWidth-1:0] RAM_address;
	wire  [dataWidth-1:0] RAM_data;
// ----------------------------------------------------------------------
//                   Instantiation
// ----------------------------------------------------------------------

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
		.interupt(interupt),.go_core(go),
		.w_r_ram(W_R_RAM),
		.data2core(data2core),
		.address2core(adress2core));

k_means_core core (
		.clk(clk),
		.rst_n(rst_n),
		.ram_address(RAM_address),
		.ram_data(RAM_data),
		.w_r_ram(W_R_RAM),
		.go(go),
		.reg_num(Reg_num),
		.reg_w_r(Reg_w_r_from_core),
		.reg_write_data(Reg_write_data_from_core),
		.interupt(interupt));





  

	 


		
	 
	
 



endmodule