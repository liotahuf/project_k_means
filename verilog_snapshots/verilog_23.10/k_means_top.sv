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

RegFile registerFile(.clk(clk),.rst_n(rst_n),.paddr(paddr),.pwrite(pwrite),.psel(psel),.penable(penable),.pwdata(pwdata),.prdata(prdata),.pready(pready),
	.Reg_num(Reg_num),.Reg_write(Reg_w_r_from_core),.Reg_write_data(Reg_write_data_from_core),.interupt(interupt),.go_core(go),.W_R_RAM(W_R_RAM),
	.Reg_read_data1(RAM_address),.Reg_read_data2(RAM_data));

k_means_core core (.clk(clk),.rst_n(rst_n),.RAM_address(RAM_address),.RAM_data(RAM_data),.W_R_RAM(W_R_RAM),.Go(go),
					.Reg_num(Reg_num),.Reg_w_r(Reg_w_r_from_core),.Reg_write_data(Reg_write_data_from_core),.interupt(interupt));





  

	 


		
	 
	
 



endmodule