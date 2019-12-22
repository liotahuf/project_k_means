/*------------------------------------------------------------------------------
 * File          : controller.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Dec 15, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module controller #(
	tc_mode           = 1,
	rem_mode          =1,
	accum_width       = 7*22,
	addrWidth         = 8,
	dataWidth         = 91,
	centroid_num      =8,
	log2_cent_num     = 3,
	accum_cord_width  = 22,
	cordinate_width   = 13,
	count_width       = 10,
	manhatten_width   = 16, //protect from overflow
	log2_of_point_cnt = 9,
	ram_word_len      = 50,
	reg_amount        = 4
) (
	input                          clk,
	input                          rst_n,
	
	//IF with k_means_core
	input                          go,
	input  [log2_of_point_cnt-1:0] first_ram_addr,     //TODO : need to see where and how we get this value
	input  [log2_of_point_cnt-1:0] last_ram_addr,      //TODO : need to see where and how we get this value
	output [reg_amount-1:0]        reg_num,
	output                         reg_write,
	
	//TODO - IF with RAM - both ram1 and ram2
	output [log2_of_point_cnt-1:0] ram_addr,
	output                         wr_en_n,
	output                         output_en_n,
	output                         chip_select_n,
	//output [ram_word_len-1:0]      ram1_input,
	//output [ram_word_len-1:0]      ram2_input,
	
	//IF with classification block
	output                         ram_input_reg_en,
	output [centroid_num-1 :0]     centroid_en,
	output                         accumulators_en,
	output                         pipe3_regs_reset_n, //pipe3
	
	//IF with new_means_calculation_block
	output                         divider_en,
	output [log2_cent_num-1:0]     cent_cnt,
	
	//IF with convergence check block
	input  [log2_cent_num-1:0]     wr_cnvrg_to_calc_cent_num,//write centroids convergence check to classification block. TODO : use or rmv this
	output                         convergence_reg_en,
	output                         convergence_regs_reset,
	input                          has_converged,
	input                          converge_res_available
);


/*----------INTERNAL CONSTANTS-------------*/
parameter log2_num_states = 5;
enum logic [log2_num_states-1:0] {
	idle,
	read_centroid,
	write_centroid,
	read_first_point_RAM,
	fill_pipe,
	classify_remain_points,
	empty_pipe,
	calculate_new_mean,
	new_cent_wr_converge_check,
	interrupt
} states;



/*----------WIRES & REGS-------------*/

reg [log2_of_point_cnt-1:0] point_cnt;
reg [log2_cent_num-1:0]  centroid_cnt;
reg [centroid_num-1 :0] centroid_en_reg;
reg [1:0] fill_cnt;//fill classification block pipe // TODO - might fix to 1 bit because its up to 3 or up to 2
//state machine regs
reg [log2_num_states-1:0] curr_state;
reg [log2_num_states-1:0] next_state;



/*----------COMB LOGIC-------------*/
assign cent_cnt = centroid_cnt;
assign centroid_en = centroid_en_reg;


/*----------FF LOGIC-------------*/

//sequential logic
always @(rst_n==0 or posedge clk) begin
	if (rst_n==0) begin
		curr_state <= idle;
	end
	else begin
		curr_state <= next_state;
	end
end

//next state logic
always @(curr_state or go or has_converged or converge_res_available) begin
	case(curr_state)
		idle : begin
			if (go) begin
				next_state <= read_centroid;
			end
		end
		read_centroid : begin
			next_state <= write_centroid;
		end
		write_centroid : begin
			if(centroid_cnt < 3'b111) begin // 3'b111 represent the amount 8
				next_state <= read_centroid;
			end
			else begin
				next_state <= read_first_point_RAM;
			end
		end
		read_first_point_RAM : begin
			next_state <= fill_pipe;
		end
		fill_pipe : begin
			if (fill_cnt < 2'b11) begin//TODO : might need to change fill_cnt to be up to 2 instead of 3 for filling
				next_state <= fill_pipe;
			end
			else begin
				next_state <= classify_remain_points;
			end
		end
		classify_remain_points : begin
			if (first_ram_addr+point_cnt == last_ram_addr) begin
				next_state <= empty_pipe;
			end
			else begin
				next_state <= classify_remain_points;
			end
		end
		empty_pipe : begin
			if (fill_cnt == 2'b00) begin
				next_state <= calculate_new_mean;
			end
		end
		calculate_new_mean : begin
			next_state <= new_cent_wr_converge_check;
		end
		new_cent_wr_converge_check : begin
			if (converge_res_available) begin
				if (has_converged) begin
					next_state <= interrupt;
				end
				else begin
					next_state <= read_first_point_RAM;
				end
			end
		end
		interrupt : begin
			//TODO : write to REGFILE the results of centroids - need to add states
		end
	endcase
end

//outputs assigning regarding curr_state
always @(rst_n==0 or posedge clk) begin
	if (rst_n==0) begin
		//internal regs
		point_cnt <= 0;
		centroid_cnt = 0;
		
		//IF with k_means_core
		reg_num = 0;
		reg_write = 0;
		
		//IF with RAM - both ram1 and ram2
		ram_addr = 0;
		wr_en_n = 1'b1;
		output_en_n = 1'b1;
		chip_select_n = 1'b1;
		//ram1_input = 0;
		//ram2_input = 0;
		
		//IF with classification block
		ram_input_reg_en = 0;
		centroid_en_reg = 0;
		accumulators_en = 0;
		pipe3_regs_reset_n = 1'b0;
		
		//IF with new_means_calculation_block
		divider_en = 0;
		
		//IF with convergence check block
		convergence_reg_en = 0;
		convergence_regs_reset = 0;
	end
	else begin
		case(curr_state)
			idle : begin
				//internal regs
				point_cnt = 0;
				centroid_cnt = 0;
				
				
				//IF with k_means_core
				reg_num = 0;
				reg_write = 0;
				
				//IF with RAM - both ram1 and ram2
				ram_addr = first_ram_addr;
				wr_en_n = 1'b1;
				output_en_n = 1'b1;
				chip_select_n = 1'b1;
				//ram1_input = 0;
				//ram2_input = 0;
				
				//IF with classification block
				ram_input_reg_en = 0;
				centroid_en_reg = 0;
				accumulators_en = 0;
				pipe3_regs_reset_n = 1'b1;
				
				//IF with new_means_calculation_block
				divider_en = 0;
				
				//IF with convergence check block
				convergence_reg_en = 0;
				convergence_regs_reset = 0;
				
			end
			read_centroid : begin
				reg_num = centroid_cnt;
				reg_write = 0;//stays - TODO : rmv this line
			end
			write_centroid : begin
				centroid_en_reg = 0;//turn down the bit which was on from last writing
				centroid_en_reg[centroid_cnt] = 1'b1;
				centroid_cnt++;
			end
			read_first_point_RAM : begin
				wr_en_n = 1'b1;//read
				ram_addr = first_ram_addr+point_cnt;
				pipe3_regs_reset_n = 1'b0;
				point_cnt++;
				fill_cnt = 0;
				//ram1_input =
				//ram2_input =
			end
			fill_pipe : begin
				pipe3_regs_reset_n = 1'b1;//stop the reset
				
				wr_en_n = 1'b1;//read
				ram_addr = first_ram_addr+point_cnt;
				point_cnt++;
				fill_cnt++;
			end
			classify_remain_points : begin
				wr_en_n = 1'b1;////stays - TODO : rmv this line
				ram_addr = first_ram_addr+point_cnt;
				accumulators_en = 1'b1;
				point_cnt++;
			end
			empty_pipe : begin
				fill_cnt--;
				accumulators_en = 1'b1;////stays - TODO : rmv this line
				
				//instead of wr_en_n = 0 : we disable the RAM from now till the end of iteration
				output_en_n = 0;
				chip_select_n = 0;
				ram_input_reg_en = 0;
			end
			calculate_new_mean : begin
				accumulators_en = 0;//turn down
				divider_en = 1'b1;
				centroid_en_reg = 0;
				centroid_en_reg[0] = 1'b1;//next clk this will be allowing write from converge block to classify block
			end
			new_cent_wr_converge_check : begin
				divider_en = 1'b1;///stays - TODO : rmv this line
				case(centroid_en_reg)//TODO - check sync of that with both blocks
					8'b00000001 : centroid_en_reg <= 8'b00000010;
					8'b00000010 : centroid_en_reg <= 8'b00000100;
					8'b00000100 : centroid_en_reg <= 8'b00001000;
					8'b00001000 : centroid_en_reg <= 8'b00010000;
					8'b00010000 : centroid_en_reg <= 8'b00100000;
					8'b00100000 : centroid_en_reg <= 8'b01000000;
					8'b01000000 : centroid_en_reg <= 8'b10000000;
					8'b10000000 : centroid_en_reg <= 8'd0;//done writing
				endcase
				
				//reg_num ? - no need to handle the write back - calc_block and converge_check_block speak with each other
				//wr_cnvrg_to_calc_cent_num TODO : use or rmv this
			end
			interrupt : begin
				//TODO
			end
		endcase
		
	end
end


































endmodule : controller