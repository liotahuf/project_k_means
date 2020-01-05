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
	input  [log2_of_point_cnt-1:0] first_ram_addr,            //TODO : need to see where and how we get this value
	input  [log2_of_point_cnt-1:0] last_ram_addr,             //TODO : need to see where and how we get this value
	output [reg_amount-1:0]        reg_num,
	output                         reg_write,
	output                         interupt,
	
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
	output                         pipe3_regs_reset_n,        //pipe3
	output                         first_iteration,
	
	//IF with new_means_calculation_block
	output                         divider_en,
	output [log2_cent_num-1:0]     cent_cnt,
	
	//IF with convergence check block
	input  [log2_cent_num-1:0]     wr_cnvrg_to_calc_cent_num, //write centroids convergence check to classification block. TODO : use or rmv this
	output                         convergence_reg_en,
	output                         convergence_regs_reset_n,
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
	write_new_cents_to_regfile,
	interrupt
} states;
//reg file reg's num
enum logic [reg_amount-1:0] { internal_status_reg,
	                          GO_reg,
	                          cent_1_reg,
	                          cent_2_reg,
	                          cent_3_reg,
	                          cent_4_reg,
	                          cent_5_reg,
	                          cent_6_reg,
	                          cent_7_reg,
	                          cent_8_reg,
	                          ram_addr_reg,
	                          ram_data_reg,
	                          first_ram_addr_reg,
	                          last_ram_addr_reg} register_num;



/*----------WIRES & REGS-------------*/

reg [log2_of_point_cnt-1:0] point_cnt;
reg [log2_cent_num-1:0]  centroid_cnt;
reg [centroid_num-1 :0] centroid_en_reg;
reg [1:0] fill_cnt;//fill classification block pipe // TODO - might fix to 1 bit because its up to 3 or up to 2
//state machine regs
reg [log2_num_states-1:0] curr_state;
reg [log2_num_states-1:0] next_state;
reg [log2_cent_num-1:0] write_to_regfile_counter;


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
					next_state <= write_new_cents_to_regfile;
				end
				else begin
					next_state <= read_first_point_RAM;
				end
			end
		end
		write_new_cents_to_regfile : begin
			if (write_to_regfile_counter == 3'd7) begin
				next_state <= interrupt;
			end
		end
		interrupt : begin
			next_state <= idle;
		end
	endcase
end

//outputs assigning regarding curr_state
always @(rst_n==0 or posedge clk) begin
	if (rst_n==0) begin
		//internal regs
		point_cnt <= 0;
		centroid_cnt = 0;
		write_to_regfile_counter <= 0;
		
		//IF with k_means_core
		reg_num = 0;
		reg_write = 0;
		interrupt = 0;
		
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
		first_iteration = 1'b1;
		
		//IF with new_means_calculation_block
		divider_en = 0;
		
		//IF with convergence check block
		convergence_reg_en = 0;
		convergence_regs_reset_n = 1'b1;
	end
	else begin
		case(curr_state)
			idle : begin
				//internal regs
				point_cnt = 0;
				centroid_cnt = 0;
				write_to_regfile_counter <= 0;
				
				//IF with k_means_core
				reg_num = 0;
				reg_write = 0;
				interrupt = 0;
				
				//IF with RAM - both ram1 and ram2
				ram_addr = first_ram_addr;//A
				wr_en_n = 1'b1;//WEB
				output_en_n = 1'b1;//OEB
				chip_select_n = 1'b1;//CSB
				//ram1_input = 0;
				//ram2_input = 0;
				
				//IF with classification block
				ram_input_reg_en = 0;
				centroid_en_reg = 0;
				accumulators_en = 0;
				pipe3_regs_reset_n = 1'b1;
				first_iteration = 1'b1;
				
				//IF with new_means_calculation_block
				divider_en = 0;
				
				//IF with convergence check block
				convergence_reg_en = 0;
				convergence_regs_reset_n = 1'b0;
				
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
				convergence_regs_reset_n = 1'b0;//reset after coming back for another iteration
				first_iteration = 1'b0;//when we come here we wont read again from REGFILE for the entire caculation
				
				
				divider_en = 1'b0;//if we came for another iteration need to drop this signal down
				//RAM IF
				wr_en_n = 1'b1;//read
				output_en_n = 1'b0;
				chip_select_n = 1'b0;
				ram_addr = first_ram_addr+point_cnt;
				//pipe 3 classify block IF
				pipe3_regs_reset_n = 1'b0;
				//internal counters
				point_cnt++;
				fill_cnt = 0;
			end
			fill_pipe : begin
				convergence_regs_reset_n = 1'b1;//turn reset off
				
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
				//internal counter
				fill_cnt--;
				//classify block IF
				accumulators_en = 1'b1;////stays - TODO : rmv this line
				ram_input_reg_en = 0;
				
				//instead of wr_en_n = 0 : we disable the RAM from now till the end of iteration
				//RAM IF
				output_en_n = 1'b1;
				chip_select_n = 1'b1;
			end
			calculate_new_mean : begin
				convergence_regs_reset_n = 1'b0;//we want to start counting converges again, lets clean last iteration garbage
				accumulators_en = 0;//turn down
				divider_en = 1'b1;
				centroid_en_reg = 0;
				centroid_en_reg[0] = 1'b1;//next clk this will be allowing write from converge block to classify block
			end
			new_cent_wr_converge_check : begin
				//IF with convergence check block
				convergence_regs_reset_n = 1'b1;//turn reset off
				convergence_reg_en = 1'b1;//now lets sample divider results
				
				divider_en = 1'b1;///stays - TODO : rmv this line
				case(centroid_en_reg)//TODO - check sync of that with both blocks
					8'b00000001 : centroid_en_reg <= 8'b00000010;
					8'b00000010 : centroid_en_reg <= 8'b00000100;
					8'b00000100 : centroid_en_reg <= 8'b00001000;
					8'b00001000 : centroid_en_reg <= 8'b00010000;
					8'b00010000 : centroid_en_reg <= 8'b00100000;
					8'b00100000 : centroid_en_reg <= 8'b01000000;
					8'b01000000 : centroid_en_reg <= 8'b10000000;
					8'b10000000 : centroid_en_reg <= 8'd0;//last write, next cycle no more writing for this iteration
				endcase
				
				//reg_num ? - no need to handle the write back - calc_block and converge_check_block speak with each other
				//wr_cnvrg_to_calc_cent_num TODO : use or rmv this
			end
			write_new_cents_to_regfile : begin
				reg_write = 1'b1;
				case (write_to_regfile_counter)
					3'd0 : reg_num = cent_1_reg;
					3'd1 : reg_num = cent_2_reg;
					3'd2 : reg_num = cent_3_reg;
					3'd3 : reg_num = cent_4_reg;
					3'd4 : reg_num = cent_5_reg;
					3'd5 : reg_num = cent_6_reg;
					3'd6 : reg_num = cent_7_reg;
					3'd7 : reg_num = cent_8_reg;
				endcase
				write_to_regfile_counter++;
			end
			interrupt : begin
				reg_write  = 1'b0;
				divider_en = 1'b0;
				interupt = 1'b1;
			end
		endcase
		
	end
end


































endmodule : controller