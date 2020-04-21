/*------------------------------------------------------------------------------
 * File          : RegFile.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Aug 21, 2019
 * Description   : Register File
 *------------------------------------------------------------------------------*/
//TODO : change bit sizes for registers later
module RegFile #(
	parameter
	addrWidth       = 9,
	dataWidth       = 91,
	reg_amount      =4,
	manhatten_width = 16
) (
	//APB signals - IF with STUB
	input                        clk,
	input                        rst_n,
	input  [addrWidth-1:0]       paddr,
	input                        pwrite,
	input                        psel,
	input                        penable,
	input  [dataWidth-1:0]       pwdata,
	//
	output [dataWidth-1:0]       prdata_out,
	output                       pready_out,
	
	//IF with k-means-core
	input                        interupt,
	input  [reg_amount-1:0]      reg_num,
	input                        reg_write,
	input  [dataWidth-1:0]       reg_write_data,
	output [dataWidth-1:0]       data2core_out,
	output [dataWidth-1:0]       address2core_out,
	output                       go_core_out,
	output                       w_r_ram_n_out,
	output                       out_en_ram_n_out,
	output                       chip_select_ram_n_out,
	output [addrWidth-1:0]       first_ram_address_out,
	output [addrWidth-1:0]       last_ram_address_out,
	output [manhatten_width-1:0] threshold_value
	
	
	
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
reg	[1:0]internal_status ;

//core interface regs
reg [dataWidth-1:0] ram_addr;
reg	[dataWidth-1:0] ram_data;
reg [addrWidth-1:0] first_ram_addr;
reg [addrWidth-1:0] last_ram_addr;
reg [dataWidth-1:0] data2core_tmp;
reg [dataWidth-1:0] data2core;
reg [dataWidth-1:0] address2core;
reg [manhatten_width-1:0] threshold;
reg go_core;
reg w_r_ram_n;
reg out_en_ram_n;
reg chip_select_ram_n;
//registers for apb interface
reg [dataWidth-1:0]       prdata;
reg                       pready;

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
enum {
	internal_status_reg = reg_amount'('h0),
	GO_reg              = reg_amount'('h1),
	cent_1_reg          = reg_amount'('h2),
	cent_2_reg          = reg_amount'('h3),
	cent_3_reg          = reg_amount'('h4),
	cent_4_reg         = reg_amount'('h5),
	cent_5_reg         = reg_amount'('h6),
	cent_6_reg         = reg_amount'('h7),
	cent_7_reg         = reg_amount'('h8),
	cent_8_reg         = reg_amount'('h9),
	ram_addr_reg       = reg_amount'('ha),
	ram_data_reg       = reg_amount'('hb),
	first_ram_addr_reg = reg_amount'('hc),
	last_ram_addr_reg  = reg_amount'('hd),
	threshold_reg      = reg_amount'('he)
} register_num;

enum {
	SETUP = 2'b00, W_ENABLE = 2'b01, R_ENABLE = 2'b10
} apb_curr_st;
reg [dataWidth-1:0] last_paddr ;
reg w_to_ram_flag;



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


/*--comb logic--*/
assign first_ram_address_out = first_ram_addr;
assign last_ram_address_out =last_ram_addr;
assign threshold_value =threshold;
assign data2core_out = data2core;
assign address2core_out = address2core;
assign prdata_out = prdata;
assign pready_out = pready;
assign go_core_out = go_core;
assign w_r_ram_n_out = w_r_ram_n;
assign out_en_ram_n_out = out_en_ram_n;
assign chip_select_ram_n_out = chip_select_ram_n;

/*-----------------------------flip flop logic----------------------------------------------------------------------*/

/* ---------------------------------- Interface with APB master ----------------------------------*/
// Interface with APB master- indirect access read or write process state machine
always @(negedge rst_n or posedge clk) begin
	if (rst_n == 0) begin
		apb_curr_st 		<= SETUP;
	end
	else begin
		case (apb_curr_st)
			SETUP : begin
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
				if (psel && penable && pwrite) begin
					apb_curr_st <= SETUP;// return to SETUP
				end
			end
			
			R_ENABLE : begin
				if (psel && penable && !pwrite) begin
					apb_curr_st <= SETUP;// return to SETUP
				end
			end
			
		endcase
	end
end

//signals changing due to state machines curr_state
always @(negedge rst_n or posedge clk) begin
	if (rst_n == 0) begin
		go_register	<=0;
		
		ram_addr 		<=0;
		ram_data 		<=0;
		first_ram_addr 	<=0;
		last_ram_addr   <=0;
		data2core  <= 91'b0;
		address2core  <=0;
		w_to_ram_flag <= 1'b0;
		data2core_tmp <=1'b0;
		threshold <= 0;
		internal_status <=0; //core in idle state
		
	end
	else begin
		//APB
		if (go_register == 1'b0) begin
			case (apb_curr_st)
				
				SETUP : begin
					// clear the prdata
					prdata <= 0;
					pready<=1'b0;
					
				end
				
				
				
				W_ENABLE : begin
					// write pwdata to memorydataWidth
					if (psel && penable && pwrite) begin
						case(paddr)
							//internal_status_reg :
							GO_reg 		 		: go_register	 <= pwdata[0];
							cent_1_reg   		: centroid_1     <= pwdata[dataWidth-1:0];
							cent_2_reg   		: centroid_2     <= pwdata[dataWidth-1:0];
							cent_3_reg   		: centroid_3     <= pwdata[dataWidth-1:0];
							cent_4_reg   		: centroid_4     <= pwdata[dataWidth-1:0];
							cent_5_reg   		: centroid_5     <= pwdata[dataWidth-1:0];
							cent_6_reg   		: centroid_6     <= pwdata[dataWidth-1:0];
							cent_7_reg   		: centroid_7     <= pwdata[dataWidth-1:0];
							cent_8_reg   		: centroid_8     <= pwdata[dataWidth-1:0];
							ram_addr_reg 		: ram_addr 		 <= pwdata[dataWidth-1:0];
							ram_data_reg 		: ram_data 		 <= pwdata[dataWidth-1:0];
							first_ram_addr_reg  : first_ram_addr <= pwdata[addrWidth-1:0];
							last_ram_addr_reg   : last_ram_addr  <= pwdata[addrWidth-1:0];
							threshold_reg       : threshold 	 <= pwdata[manhatten_width-1:0];
							
						endcase
						pready<=1'b1;
						last_paddr <= paddr;
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
							ram_addr_reg 		: prdata 	 <= ram_addr ;
							ram_data_reg 		: prdata     <= ram_data ;
							first_ram_addr_reg  : begin
								prdata <= 0;
								prdata[addrWidth-1:0]     <=first_ram_addr ;
							end
							
							
							last_ram_addr_reg   : begin
								prdata <= 0;
								prdata[addrWidth-1:0]     <= last_ram_addr ;
							end
							threshold_reg       : begin
								prdata <= 0;
								prdata[manhatten_width-1:0] 	 <= threshold;
							end
						endcase
					end
					
				end
			endcase
		end
		
		// if interrupt signal is high then the host cannot give go
		if (interupt ==1'b1) begin
			go_register	<=1'b0;
			internal_status <=2'b 10;//core done,interrupt is togled
		end
		
		//Interface with core- read and write to registers in RegFile
		if(go_register==1'b1) begin
			//read from register number "reg_num" of RegFile
			if(reg_write==1'b0) begin
				case(reg_num)
					cent_1_reg   		  : data2core_tmp     <= centroid_1;
					cent_2_reg   		  : data2core_tmp     <= centroid_2 ;
					cent_3_reg   		  : data2core_tmp     <= centroid_3 ;
					cent_4_reg   		  : data2core_tmp     <= centroid_4;
					cent_5_reg   		  : data2core_tmp     <= centroid_5 ;
					cent_6_reg   		  : data2core_tmp     <= centroid_6 ;
					cent_7_reg   		  : data2core_tmp     <= centroid_7 ;
					cent_8_reg   	      : data2core_tmp     <= centroid_8 ;
					ram_addr_reg 		  : data2core_tmp 	   <= ram_addr ;
					ram_data_reg 		  : data2core_tmp     <= ram_data ;
					first_ram_addr_reg  : data2core_tmp     <=first_ram_addr ;
					last_ram_addr_reg   : data2core_tmp     <= last_ram_addr ;
				endcase
				data2core <=data2core_tmp;
			end
			else begin
				//write to register number "reg_num" of RegFile
				case(reg_num)
					
					cent_1_reg   		  : centroid_1     <= reg_write_data[dataWidth-1:0];
					cent_2_reg   		  : centroid_2     <= reg_write_data[dataWidth-1:0];
					cent_3_reg   		  : centroid_3     <= reg_write_data[dataWidth-1:0];
					cent_4_reg   		  : centroid_4     <= reg_write_data[dataWidth-1:0];
					cent_5_reg   		  : centroid_5     <= reg_write_data[dataWidth-1:0];
					cent_6_reg   		  : centroid_6     <= reg_write_data[dataWidth-1:0];
					cent_7_reg   		  : centroid_7     <= reg_write_data[dataWidth-1:0];
					cent_8_reg   	      : centroid_8     <= reg_write_data[dataWidth-1:0];
					
					
				endcase
			end
			
			
		end
	end
end


/* ---------------------------------- Interface with core ----------------------------------*/

//Interface with core - set go signal to core
always @(negedge rst_n or posedge clk) begin
	if (rst_n == 1'b0) begin
		go_core<=1'b0;
	end
	else if (go_register==1'b1) begin
		go_core<=1'b1;
		internal_status <=2'b 01;//core busy,algorithm running
		
	end
	else begin
		go_core<=1'b0;
	end
end

//Interface with core- write to RAM
always @(negedge rst_n or  posedge clk) begin
	if (rst_n == 1'b0) begin
		data2core <= 91'b0 ;
		address2core <= 91'b0;//TODO: fix size
		w_to_ram_flag <= 1'b0;
		w_r_ram_n <= 1'b1;
		out_en_ram_n <= 1'b1;
		chip_select_ram_n <= 1'b1;
	end
	else if(go_register==1'b0) begin
		
		data2core<=91'b0;
		address2core<=91'b0;
		//
		w_r_ram_n<=1'b1;
		chip_select_ram_n <= 1'b1;
		//
		if (last_paddr[7:0]==ram_addr_reg && paddr[7:0]==ram_data_reg && go_register==1'b0) begin
			
			w_to_ram_flag <= 1'b1;
		end
		if (w_to_ram_flag && last_paddr[7:0]==ram_data_reg) begin
			//if register written to is ram_data_reg then the ram_addr_reg was already updated. Therefore, write to RAM
			data2core<=ram_data;
			address2core<=ram_addr;// is now DATA to write to RAM
			//
			w_r_ram_n<=1'b0;
			chip_select_ram_n <= 1'b0;
			//
			w_to_ram_flag <= 1'b0;
		end
	end
end






endmodule


