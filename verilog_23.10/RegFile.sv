/*------------------------------------------------------------------------------
 * File          : RegFile.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   : Register File
 *------------------------------------------------------------------------------*/
//TODO : change bit sizes for registers later
module RegFile #(addrWidth = 8, dataWidth = 91) (
	//APB signals
	input                        clk,
	input                        rst_n,
	input        [addrWidth-1:0] paddr,
	input                        pwrite,
	input                        psel,
	input                        penable,
	input        [dataWidth-1:0] pwdata,
	input        [addrWidth-1:0] Reg_num,
	input                        Reg_write,
	input        [dataWidth-1:0] Reg_write_data,
	
	
	output logic [dataWidth-1:0] prdata,
	output logic                 pready,
	
	//signals core interface
	
	input                        interupt,
	output logic [dataWidth-1:0] Reg_read_data1,
	output logic [dataWidth-1:0] Reg_read_data2,
	output logic                 go_core,
	output logic                 W_R_RAM
	
	
	
);

/*TODO processes for regfile
 *interface with STUB(the cpu) :
 *	accept by apb protocol data to write to the registers - V
 *
 *  interface with k means core : -V
 *
 *
 */
 
 
//cmd interface regs
reg	go_register;
reg	[addrWidth-1:0]internal_status;

//read or write reg's

reg [addrWidth-1:0] ram_addr;
reg	[dataWidth-1:0] ram_data;
reg [addrWidth-1:0] first_ram_addr;
reg [addrWidth-1:0] last_ram_addr;

//centroids
reg [dataWidth-1:0] centroid_1;
reg [dataWidth-1:0] centroid_2;
reg [dataWidth-1:0] centroid_3;
reg [dataWidth-1:0] centroid_4;
reg [dataWidth-1:0] centroid_5;
reg [dataWidth-1:0] centroid_6;
reg [dataWidth-1:0] centroid_7;
reg [dataWidth-1:0] centroid_8;

//reg [dataWidth-1:0] regFile [256];
enum logic [7:0] { internal_status_reg,GO_reg,cent_1_reg,cent_2_reg,cent_3_reg,cent_4_reg,cent_5_reg,cent_6_reg,cent_7_reg,cent_8_reg,
	               RAM_addr_reg,RAM_data_reg,first_ram_addr_reg,last_ram_addr_reg} register_num;

enum logic	[1:0] {SETUP, W_ENABLE, R_ENABLE} apb_curr_st;
reg [addrWidth-1:0] last_paddr ;


//wire logic [dataWidth-1:0] RAM_adress;
//wire logic [dataWidth-1:0] RAM_data;
////wire logic  			     wire_Go;
//wire logic                 wire_W_R_RAM;
//wire logic [addrWidth-1:0] Reg_addr_from_core;
//wire logic                 Reg_w_r_from_core;
//reg 						 cen_en1;
//reg 						 cen_en2;
//reg 						 cen_en3;
//reg 						 cen_en4;
//reg 						 cen_en5;
//reg 						 cen_en6;
//reg 						 cen_en7;
//reg 						 cen_en8;




/* ---------------------------------- Interface with APB master ----------------------------------*/

// Interface with APB master- indirect access read or write process
always @(rst_n==0 or posedge clk) begin
	if (rst_n == 0) begin
		apb_curr_st 		<= SETUP;
	end
	else begin
		case (apb_curr_st)
			
			SETUP : begin
				// clear the prdata
				prdata <= '0;
				pready<=1'b0;
				if (~go_register && psel && ~penable) begin
					// Move to ENABLE when the psel is asserted
					if (pwrite) begin
						apb_curr_st <= W_ENABLE;
					end
					else begin
						apb_curr_st<= R_ENABLE;
						
					end
				end
			end
			
			
			W_ENABLE : begin
				// write pwdata to memory
				if (psel && penable && pwrite) begin
					case(paddr)
						//internal_status_reg :
						GO_reg 		 		: go_register	   	 <= pwdata[0];
						cent_1_reg   		: centroid_1     <= pwdata[dataWidth-1:0];
						cent_2_reg   		: centroid_2     <= pwdata[dataWidth-1:0];
						cent_3_reg   		: centroid_3     <= pwdata[dataWidth-1:0];
						cent_4_reg   		: centroid_4     <= pwdata[dataWidth-1:0];
						cent_5_reg   		: centroid_5     <= pwdata[dataWidth-1:0];
						cent_6_reg   		: centroid_6     <= pwdata[dataWidth-1:0];
						cent_7_reg   		: centroid_7     <= pwdata[dataWidth-1:0];
						cent_8_reg   		: centroid_8     <= pwdata[dataWidth-1:0];
						RAM_addr_reg 		: ram_addr 		 <= pwdata[addrWidth-1:0];
						RAM_data_reg 		: ram_data 		 <= pwdata[dataWidth-1:0];
						first_ram_addr_reg  : first_ram_addr <= pwdata[addrWidth-1:0];
						last_ram_addr_reg   : last_ram_addr  <= pwdata[addrWidth-1:0];
						
					endcase
					
					
					pready<=1'b1;
					last_paddr <= paddr;
					apb_curr_st <= SETUP;// return to SETUP
				end
				
			end
			
			R_ENABLE : begin
				// read prdata from memory
				if (psel && penable && !pwrite) begin
					
					pready<=1'b1;
					apb_curr_st <= SETUP;// return to SETUP
					
					case(paddr)
						internal_status_reg : begin
							prdata[addrWidth-1:0]         <= internal_status;
							prdata[dataWidth-1:addrWidth] <=0;
						end
						GO_reg 		 		: begin
							prdata[0]	 <= go_register;
							prdata[dataWidth-1:1] <=0;
						end
						cent_1_reg   		: prdata     <= centroid_1;
						cent_2_reg   		: prdata     <= centroid_2 ;
						cent_3_reg   		: prdata     <= centroid_3 ;
						cent_4_reg   		: prdata     <= centroid_4;
						cent_5_reg   		: prdata     <= centroid_5 ;
						cent_6_reg   		: prdata     <= centroid_6 ;
						cent_7_reg   		: prdata     <= centroid_7 ;
						cent_8_reg   		: prdata     <= centroid_8 ;
						RAM_addr_reg 		: prdata 	 <= ram_addr ;
						RAM_data_reg 		: prdata     <= ram_data ;
						first_ram_addr_reg  : prdata     <=first_ram_addr ;
						last_ram_addr_reg   : prdata     <= last_ram_addr ;
						
					endcase
				end
				
			end
		endcase
	end
end

//Update go_register in case of reset or interrupt
always @(rst_n==0 or posedge clk) begin
	if (rst_n == 0) begin
		go_register	<=0;
		
	end
	
	else begin
		if(interupt ==1) begin
			go_register	<=0;
		end
		
	end
end

/* ---------------------------------- Interface with core ----------------------------------*/

//Interface with core - set go signal to core
always @(rst_n==0 or posedge clk) begin
	if (rst_n == 0) begin
		go_core<=0;
	end
	else if (go_register==1) begin
		go_core<=1;
		
	end
	else begin
		go_core<=0;
	end
end

//Interface with core- write to RAM
always @(rst_n==0 or posedge clk) begin
	if (rst_n == 0) begin
		ram_addr 		<=0;
		ram_data 		<=0;
		first_ram_addr 	<=0;
		last_ram_addr   <=0;
		Reg_read_data1  <=0;
		Reg_read_data2  <=0;
		W_R_RAM         <=0;
	end
	else begin
		Reg_read_data1<=0 ;
		Reg_read_data2<=0;// is now DATA to write to RAM
		W_R_RAM<=0;
		if (last_paddr==RAM_data_reg && go_register==0) begin
			//if register written to is RAM_data_reg then the RAM_addr_reg was already updated. Therefore, write to RAM
			Reg_read_data1<=ram_addr ;
			Reg_read_data2<=ram_data;// is now DATA to write to RAM
			W_R_RAM<=1'b1;
			last_paddr<=internal_status_reg;
		end
		
		
		
		
	end
end


//Interface with core- read and write to registers in RegFile
always @(rst_n==0 or posedge clk) begin
	if (rst_n == 0) begin
		centroid_1  	<=0;
		centroid_2      <=0;
		centroid_3     	<=0;
		centroid_4     	<=0;
		centroid_5     	<=0;
		centroid_6     	<=0;
		centroid_7     	<=0;
		centroid_8     	<=0;
	end
	else begin
		if(go_register==1) begin
			//			cen_en1    <= 1'b0;
			//			cen_en2    <= 0;
			//			cen_en3    <= 0;
			//			cen_en4    <= 0;
			//			cen_en5    <= 0;
			//			cen_en6    <= 0;
			//			cen_en7    <= 0;
			//			cen_en8    <= 0;
			
			//read from register number "Reg_num" of RegFile
			if(Reg_write==0) begin
				case(Reg_num)
					cent_1_reg   		  : Reg_read_data1     <= centroid_1;
					cent_2_reg   		  : Reg_read_data1     <= centroid_2 ;
					cent_3_reg   		  : Reg_read_data1     <= centroid_3 ;
					cent_4_reg   		  : Reg_read_data1     <= centroid_4;
					cent_5_reg   		  : Reg_read_data1     <= centroid_5 ;
					cent_6_reg   		  : Reg_read_data1     <= centroid_6 ;
					cent_7_reg   		  : Reg_read_data1     <= centroid_7 ;
					cent_8_reg   	      : Reg_read_data1     <= centroid_8 ;
					RAM_addr_reg 		  : Reg_read_data1 	   <= ram_addr ;
					RAM_data_reg 		  : Reg_read_data1     <= ram_data ;
					first_ram_addr_reg  : Reg_read_data1     <=first_ram_addr ;
					last_ram_addr_reg   : Reg_read_data1     <= last_ram_addr ;
				endcase
			end
			else begin
				//write to register number "Reg_num" of RegFile
				case(Reg_num)
					
					cent_1_reg   		  : centroid_1     <= Reg_write_data[dataWidth-1:0];
					cent_2_reg   		  : centroid_2     <= Reg_write_data[dataWidth-1:0];
					cent_3_reg   		  : centroid_3     <= Reg_write_data[dataWidth-1:0];
					cent_4_reg   		  : centroid_4     <= Reg_write_data[dataWidth-1:0];
					cent_5_reg   		  : centroid_5     <= Reg_write_data[dataWidth-1:0];
					cent_6_reg   		  : centroid_6     <= Reg_write_data[dataWidth-1:0];
					cent_7_reg   		  : centroid_7     <= Reg_write_data[dataWidth-1:0];
					cent_8_reg   	      : centroid_8     <= Reg_write_data[dataWidth-1:0];
					
					
				endcase
			end
		end
	end
end

//always @(rst_n==0 or posedge clk) begin
//	if (rst_n != 0) begin
//		if(go_register==1) begin
//			if(cen_en1==1) begin
//				centroid_1     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en2==1) begin
//				centroid_2     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en3==1) begin
//				centroid_3     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en4==1) begin
//				centroid_4     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en5==1) begin
//				centroid_5     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en6==1) begin
//				centroid_6     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en7==1) begin
//				centroid_7     <= Reg_write_data[dataWidth-1:0];
//
//			end
//			if(cen_en8==1) begin
//				centroid_8     <= Reg_write_data[dataWidth-1:0];
//
//			end
//		end
//	end
//end

endmodule



