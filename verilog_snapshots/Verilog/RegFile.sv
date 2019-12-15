/*------------------------------------------------------------------------------
 * File          : RegFile.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   : Register File
 *------------------------------------------------------------------------------*/
//TODO : change bit sizes for registers later
module RegFile #(
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
	input 		 [addrWidth-1:0] Reg_num,
	input 						 Reg_write,
	input        [dataWidth-1:0] Reg_write_data,
	
	output logic [dataWidth-1:0] prdata,
	output     				     pready,
	
	//signals FROM/ core
	
	
	output logic [dataWidth-1:0] Reg_read_data1,
	output logic [dataWidth-1:0] Reg_read_data2,
	output     				   	 Go,
	output						 W_R_RAM
	
   
	
  );

	/*TODO processes for regfile
	 *interface with STUB(the cpu) :
	 *	accept by apb protocol data to write to the registers - V
	 *	
	 *interface with k means core :
	 *	
	 *
	*/
	//cmd interface regs
	reg	go_reg;
	reg	[addrWidth-1:0]internal_status;
	
	//read or write reg's
	reg interupt;
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
	  
	  reg [dataWidth-1:0] regFile [256];
	  enum logic [7:0] {internal_status_reg,GO_reg,cent_1_reg,cent_2_reg,cent_3_reg,cent_4_reg,cent_5_reg,cent_6_reg,cent_7_reg,cent_8_reg,
		  RAM_addr_reg,RAM_data_reg,first_ram_addr_reg,last_ram_addr_reg} register_num;

	  enum logic	[1:0] {SETUP, W_ENABLE, R_ENABLE} apb_curr_st,apb_nxt_st;
	  reg [addrWidth-1:0] last_paddr ;
	  
	  
	  wire logic [dataWidth-1:0] RAM_adress;
	  wire logic [dataWidth-1:0] RAM_data;
	  wire logic  			     wire_Go;
	  wire logic                 wire_W_R_RAM;
	  wire logic [addrWidth-1:0] Reg_addr_from_core;
	  wire logic                 Reg_w_r_from_core;
	  reg 						 cen_en1;
	  reg 						 cen_en2;
	  reg 						 cen_en3;
	  reg 						 cen_en4;
	  reg 						 cen_en5;
	  reg 						 cen_en6;
	  reg 						 cen_en7;
	  reg 						 cen_en8;
 
  // indirect access read or write process
 
	always @(rst_n==0 or posedge clk) begin
		if (rst_n == 0) begin
			apb_curr_st 		<= SETUP;
			go_reg			<=0;
			centroid_1  	<=0;
			centroid_2      <=0;
			centroid_3     	<=0;
			centroid_4     	<=0;
			centroid_5     	<=0;
			centroid_6     	<=0;
			centroid_7     	<=0;
			centroid_8     	<=0;
			ram_addr 		<=0; 
			ram_data 		<=0;
			first_ram_addr 	<=0; 
			last_ram_addr   <=0;
		end
		else begin
			apb_curr_st<= apb_nxt_st;
			
			// synchronous write from core to reg file
			if(GO_reg==1) begin
				if(cen_en1==1) begin
					centroid_1     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en2==1) begin
					centroid_2     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en3==1) begin
					centroid_3     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en4==1) begin
					centroid_4     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en5==1) begin
					centroid_5     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en6==1) begin
					centroid_6     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en7==1) begin
					centroid_7     <= Reg_write_data[dataWidth-1:0];
					
				end
				if(cen_en8==1) begin
					centroid_8     <= Reg_write_data[dataWidth-1:0];
					
				end
			end	
		end
	end

  
	always @(apb_curr_st) begin
		case (apb_curr_st) 
			SETUP : begin
		  	// clear the prdata
		 	 prdata <= 0;
		  	pready<=1'b0;
		 		  
		 	 // Move to ENABLE when the psel is asserted
			  if (psel && !penable) begin
				if (pwrite) begin
					apb_nxt_st <= W_ENABLE;
				end
				else begin
					apb_nxt_st<= R_ENABLE;
				  
				end
			  end
			end

			W_ENABLE : begin
			  // write pwdata to memory 
			  if (psel && penable && pwrite && go_reg!=1'b1) begin
				  case(paddr)
					//internal_status_reg : 
					GO_reg 		 		: go_reg	   	 <= pwdata[0]; 
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
				  apb_nxt_st <= SETUP;// return to SETUP
				end
		  
			end

			R_ENABLE : begin
			  // read prdata from memory
			  if (psel && penable && !pwrite) begin
				
				pready<=1'b1;
				apb_nxt_st <= SETUP;// return to SETUP
				
				case(paddr)
					internal_status_reg : begin
										  	prdata[addrWidth-1:0]         <= internal_status;
										  	prdata[dataWidth-1:addrWidth] <=0;
										  end
					GO_reg 		 		: begin
											prdata[0]	 <= go_reg;
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

  
  
  //Interface with core- write to RAM 
  always@(last_paddr==RAM_data_reg) begin
	  //if register written to is RAM_data_reg then the RAM_addr_reg was already updated. Therefore, write to RAM
	  if (last_paddr==RAM_data_reg) begin
		  Reg_read_data1=ram_addr ;
		  Reg_read_data2=ram_data;// is now DATA to write to RAM
		  W_R_RAM<=1'b1;
	  end
	  else if (GO_reg==1) begin
		  Go=1;
	  end
  end
  
  //Interface with core- read register
  always@(Reg_num)
	  if(GO_reg==1) begin
		  cen_en1    <= 1'b0; 
		  cen_en2    <= 0;
		  cen_en3    <= 0;
		  cen_en4    <= 0;
		  cen_en5    <= 0;
		  cen_en6    <= 0;
		  cen_en7    <= 0;
		  cen_en8    <= 0;
		  
		  
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
			  case(Reg_num)
				  
					cent_1_reg   		  : cen_en1    <= 1; 
					cent_2_reg   		  : cen_en2    <= 1;
					cent_3_reg   		  : cen_en3    <= 1;
					cent_4_reg   		  : cen_en4    <= 1;
					cent_5_reg   		  : cen_en5    <= 1;
					cent_6_reg   		  : cen_en6    <= 1;
					cent_7_reg   		  : cen_en7    <= 1;
					cent_8_reg   	      : cen_en8    <= 1;
					
					
					endcase
				end  
	  end


  endmodule



