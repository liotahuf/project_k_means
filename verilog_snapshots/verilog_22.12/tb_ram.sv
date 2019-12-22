/*------------------------------------------------------------------------------
 * File          : tb_ram.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Dec 22, 2019
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
module tb_ram #() ();


spram512x50_cb spram512x50_cb(
 	
);

endmodule : tb_ram