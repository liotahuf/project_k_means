/*------------------------------------------------------------------------------
 * File          : tb_conv_check.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Dec 15, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module tb_conv_check #(

	tc_mode          = 1,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10,
	manhatten_width  = 16 //protect from overflow
) ();


reg                 clk;
reg                 rst_n;
//IF-controller
reg                 convergence_reg_en;
reg                 convergence_reg_reset;
wire               has_converged;

//IF k-means-core
reg [dataWidth-1:0] thresh_hold; //TODO : figure how we get this input

//IF classification_block
reg [dataWidth-1:0] old_centroid_reg_1;
reg [dataWidth-1:0] old_centroid_reg_2;
reg [dataWidth-1:0] old_centroid_reg_3;
reg [dataWidth-1:0] old_centroid_reg_4;
reg [dataWidth-1:0] old_centroid_reg_5;
reg [dataWidth-1:0] old_centroid_reg_6;
reg [dataWidth-1:0] old_centroid_reg_7;
reg [dataWidth-1:0] old_centroid_reg_8;

//IF new_means_calculation_block
reg [dataWidth-1:0] new_centroid_in;
reg [2:0]           cent_num;
wire [dataWidth-1:0] new_centroid_out;
wire converge_res_available;

/*----------Instantiation------------*/
convergence_check_block convergence_check_block(
	.clk(clk),
	.rst_n(rst_n),
	.convergence_reg_en(convergence_reg_en),
	.convergence_regs_reset(convergence_reg_reset),
	.has_converged(has_converged),
	.thresh_hold(thresh_hold),
	.old_centroid_reg_1(old_centroid_reg_1),
	.old_centroid_reg_2(old_centroid_reg_2),
	.old_centroid_reg_3(old_centroid_reg_3),
	.old_centroid_reg_4(old_centroid_reg_4),
	.old_centroid_reg_5(old_centroid_reg_5),
	.old_centroid_reg_6(old_centroid_reg_6),
	.old_centroid_reg_7(old_centroid_reg_7),
	.old_centroid_reg_8(old_centroid_reg_8),
	.new_centroid_in(new_centroid_in),
	.new_centroid_out(new_centroid_out),
	.cent_num(cent_num),
	.converge_res_available(converge_res_available)
) ;


//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;


task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		convergence_reg_en = 1'b0;
		convergence_reg_reset = 1'b0;
		thresh_hold =  0;
		//
		old_centroid_reg_1 = 91'b0;
		old_centroid_reg_2 = 91'b0;
		old_centroid_reg_3 = 91'b0;
		old_centroid_reg_4 = 91'b0;
		old_centroid_reg_5 = 91'b0;
		old_centroid_reg_6 = 91'b0;
		old_centroid_reg_7 = 91'b0;
		old_centroid_reg_8 = 91'b0;
		
		new_centroid_in = 91'b0;
		cent_num  = 3'b0;
		//

		
		#2.5 rst_n = 1'b1;
		convergence_reg_reset = 1'b1;
	end
endtask

task set_inputs;
	input [dataWidth-1 :0] old_cent;
	input [dataWidth-1 :0] new_cent;
	input [2:0]				 cent_cnt;
	input [dataWidth-1:0] thresh;
	begin
		
		thresh_hold = thresh;
		cent_num =cent_cnt;
		case (cent_cnt)
			3'd0 : begin
				old_centroid_reg_1 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd1 : begin
				old_centroid_reg_2 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd2 : begin				
				old_centroid_reg_3 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd3 : begin
				old_centroid_reg_4 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd4 : begin
				old_centroid_reg_5 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd5 : begin
				old_centroid_reg_6 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd6 : begin
				old_centroid_reg_7 = old_cent;
				new_centroid_in = new_cent;
			end
			3'd7 : begin
				old_centroid_reg_8 = old_cent;
				new_centroid_in = new_cent;
			end
		endcase
	end
endtask	
initial begin
		initiate_all;
		#10
				convergence_reg_en = 1'b1;
				set_inputs({78'b0,13'b0},{78'b0,13'b0},3'b0,{91'd10});
		#10
				set_inputs({78'b0,13'b1},{78'b0,13'b0},3'b001,{91'd10});
		#10
				set_inputs({78'b0,13'd2},{78'b0,13'b0},3'd2,{91'd10});
		#10
				set_inputs({78'b0,13'd3},{78'b0,13'b0},3'd3,{91'd10});
		#10		
				set_inputs({78'b0,13'd4},{78'b0,13'b0},3'd4,{91'd10});
		#10
				set_inputs({78'b0,13'd5},{78'b0,13'b0},3'd5,{91'd10});
		
		#10
				set_inputs({78'b0,13'd6},{78'b0,13'b0},3'd6,{91'd10});
		#10
				set_inputs({78'b0,13'd7},{78'b0,13'b0},3'd7,{91'd10});
		#15
		if(converge_res_available) begin
			convergence_reg_reset=0;
		end
		#10
				convergence_reg_reset=1;
				convergence_reg_en = 1'b1;
				set_inputs({78'b0,13'b0},{78'b0,13'b0},3'b0,{91'd10});
		#10
				set_inputs({78'b0,13'b1},{78'b0,13'b0},3'b001,{91'd10});
		#10
				set_inputs({78'b0,13'd2},{78'b0,13'b0},3'd2,{91'd10});
		#10
				set_inputs({78'b0,13'd3},{78'b0,13'b0},3'd3,{91'd10});
		#10		
				set_inputs({78'b0,13'd4},{78'b0,13'b0},3'd4,{91'd10});
		#10
				set_inputs({78'b0,13'd5},{78'b0,13'b0},3'd5,{91'd10});
		
		#10
				set_inputs({78'b0,13'd6},{78'b0,13'b0},3'd6,{91'd10});
		#10
				set_inputs({78'b0,13'd11},{78'b0,13'b0},3'd7,{91'd10});
	
		#30
				$finish;
end
		
	

endmodule : tb_conv_check