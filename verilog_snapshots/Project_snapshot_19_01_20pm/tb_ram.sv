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

reg [`numAddr-1:0] A;
reg [`numAddr-1:0] I;
reg[`numAddr-1:0] O;
reg CEB,WEB,OEB,CSB;

spram512x50_cb RAM (
	.A  (A  ),
	.CEB(CEB),
	.WEB(WEB),
	.OEB(OEB),
	.CSB(CSB),
	.I  (I  ),
	.O  (O  )
);


//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 CEB = ~CEB;


task write_to_RAM;
	input [`numAddr-1:0] Addr;
	input [`numAddr-1:0] Input;
	begin
		CSB<=0;
		WEB<=0;
		
		I<=Input;
		A<=Addr;
		#10;
	end
	
endtask


task read_from_RAM;
	input [`numAddr-1:0] Addr;
	
	begin
		CSB<=0;
		WEB<=1;
		
		
		A<=Addr;
		#10;
	end
	
endtask


initial begin
	CEB<=1;
	WEB<=1;
	CSB<=1;
	OEB<=0;
	#10
			write_to_RAM(0,1);
	
	WEB<=1;
	CSB<=1;
	
			read_from_RAM(0);
	
	WEB<=1;
	CSB<=1;
	write_to_RAM(0,2);
	WEB<=1;
	CSB<=1;
	#10
	read_from_RAM(0);
	#10
	
	
	$finish;
end

endmodule : tb_ram


