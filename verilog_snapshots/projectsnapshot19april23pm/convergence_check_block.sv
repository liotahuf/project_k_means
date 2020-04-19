/*------------------------------------------------------------------------------
 * File          : convergence_check_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Dec 11, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module convergence_check_block #(
	parameter
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
) (
	input                        clk,
	input                        rst_n,
	//IF-controller
	input                        convergence_reg_en,
	input                        convergence_regs_reset_n,
	output                       has_converged,
	output                       converge_res_available,
	
	//IF k-means-core
	input  [manhatten_width-1:0] thresh_hold,
	
	//IF classification_block
	input  [dataWidth-1:0]       old_centroid_reg_1,
	input  [dataWidth-1:0]       old_centroid_reg_2,
	input  [dataWidth-1:0]       old_centroid_reg_3,
	input  [dataWidth-1:0]       old_centroid_reg_4,
	input  [dataWidth-1:0]       old_centroid_reg_5,
	input  [dataWidth-1:0]       old_centroid_reg_6,
	input  [dataWidth-1:0]       old_centroid_reg_7,
	input  [dataWidth-1:0]       old_centroid_reg_8,
	
	//IF new_means_calculation_block
	input  [dataWidth-1:0]       new_centroid_in,
	input  [2:0]                 cent_num,
	input                        divide_by_0,
	output [dataWidth-1:0]       new_centroid_out
);


/*----------WIRES & REGS-------------*/

//substraction operation wires to create abs(old_cent-new_cent)
reg [dataWidth-1:0] old_centroid;
wire [cordinate_width-1:0] cord_old_cent_1;
wire [cordinate_width-1:0] cord_old_cent_2;
wire [cordinate_width-1:0] cord_old_cent_3;
wire [cordinate_width-1:0] cord_old_cent_4;
wire [cordinate_width-1:0] cord_old_cent_5;
wire [cordinate_width-1:0] cord_old_cent_6;
wire [cordinate_width-1:0] cord_old_cent_7;
//
wire [cordinate_width-1:0] centroids_diff_cord_1;
wire [cordinate_width-1:0] centroids_diff_cord_2;
wire [cordinate_width-1:0] centroids_diff_cord_3;
wire [cordinate_width-1:0] centroids_diff_cord_4;
wire [cordinate_width-1:0] centroids_diff_cord_5;
wire [cordinate_width-1:0] centroids_diff_cord_6;
wire [cordinate_width-1:0] centroids_diff_cord_7;
//
wire [cordinate_width-1:0] centroids_abs_diff_cord_1;
wire [cordinate_width-1:0] centroids_abs_diff_cord_2;
wire [cordinate_width-1:0] centroids_abs_diff_cord_3;
wire [cordinate_width-1:0] centroids_abs_diff_cord_4;
wire [cordinate_width-1:0] centroids_abs_diff_cord_5;
wire [cordinate_width-1:0] centroids_abs_diff_cord_6;
wire [cordinate_width-1:0] centroids_abs_diff_cord_7;

//count convergence related wires
reg  [3:0] convergence_reg;//need to count from 0 to 8
wire [manhatten_width-1:0] manhatten_dist;
wire under_thresh_hold;
//
wire done_threshold_evaluation;//needed for memorize delay of clk before having the result of convergence
reg check_convergence;//used for the "Has converged" sub-block
reg converge_result_available_reg;

//eddy 19.1
reg [dataWidth-1:0] new_centroid_out_reg;

/*-------------COMB LOGIC------------------*/
//ORDER MATTERS in the comb logic area!
//mux for divisor and dividend
always @(cent_num) begin
	case (cent_num)
		3'd0 : begin
			old_centroid = old_centroid_reg_1;
		end
		3'd1 : begin
			old_centroid = old_centroid_reg_2;
		end
		3'd2 : begin
			old_centroid = old_centroid_reg_3;
		end
		3'd3 : begin
			old_centroid = old_centroid_reg_4;
		end
		3'd4 : begin
			old_centroid = old_centroid_reg_5;
		end
		3'd5 : begin
			old_centroid = old_centroid_reg_6;
		end
		3'd6 : begin
			old_centroid = old_centroid_reg_7;
		end
		3'd7 : begin
			old_centroid = old_centroid_reg_8;
		end
		default : begin//will never get here
			old_centroid = 91'b0;
		end
	endcase
end

//ORDER MATTERS in the comb logic area!
//parsing the centroid to 7 cords and subtracting the new to old centroid
//cord 1
assign centroids_diff_cord_1 = old_centroid[1*cordinate_width-1:0*cordinate_width] - new_centroid_in[1*cordinate_width-1:0*cordinate_width];
assign centroids_abs_diff_cord_1 = (centroids_diff_cord_1 [12] == 1'b0) ? centroids_diff_cord_1 : (-centroids_diff_cord_1);
//cord 2
assign centroids_diff_cord_2 = old_centroid[2*cordinate_width-1:1*cordinate_width] - new_centroid_in[2*cordinate_width-1:1*cordinate_width];
assign centroids_abs_diff_cord_2 = (centroids_diff_cord_2[12] == 1'b0) ? centroids_diff_cord_2 : (-centroids_diff_cord_2);
//cord 3
assign centroids_diff_cord_3 = old_centroid[3*cordinate_width-1:2*cordinate_width] - new_centroid_in[3*cordinate_width-1:2*cordinate_width];
assign centroids_abs_diff_cord_3 = (centroids_diff_cord_3 [12] == 1'b0) ? centroids_diff_cord_3 : (-centroids_diff_cord_3);
//cord 4
assign centroids_diff_cord_4 = old_centroid[4*cordinate_width-1:3*cordinate_width] - new_centroid_in[4*cordinate_width-1:3*cordinate_width];
assign centroids_abs_diff_cord_4 = (centroids_diff_cord_4 [12] == 1'b0) ? centroids_diff_cord_4 : (-centroids_diff_cord_4);
//cord 5
assign centroids_diff_cord_5 = old_centroid[5*cordinate_width-1:4*cordinate_width] - new_centroid_in[5*cordinate_width-1:4*cordinate_width];
assign centroids_abs_diff_cord_5 = (centroids_diff_cord_5 [12] == 1'b0) ? centroids_diff_cord_5 : (-centroids_diff_cord_5);
//cord 6
assign centroids_diff_cord_6 = old_centroid[6*cordinate_width-1:5*cordinate_width] - new_centroid_in[6*cordinate_width-1:5*cordinate_width];
assign centroids_abs_diff_cord_6 = (centroids_diff_cord_6 [12] == 1'b0) ? centroids_diff_cord_6 : (-centroids_diff_cord_6);
//cord 7
assign centroids_diff_cord_7 = old_centroid[7*cordinate_width-1:6*cordinate_width] - new_centroid_in[7*cordinate_width-1:6*cordinate_width];
assign centroids_abs_diff_cord_7 = (centroids_diff_cord_7 [12] == 1'b0) ? centroids_diff_cord_7 : (-centroids_diff_cord_7);

//ORDER MATTERS in the comb logic area!
assign manhatten_dist = centroids_abs_diff_cord_1 + centroids_abs_diff_cord_2 + centroids_abs_diff_cord_3 + centroids_abs_diff_cord_4 + centroids_abs_diff_cord_5
		+ centroids_abs_diff_cord_6 + centroids_abs_diff_cord_7;
assign under_thresh_hold = (divide_by_0==1'b1) ?   1'b1 : ((manhatten_dist <= thresh_hold) ? 1'b1 : 1'b0);

assign done_threshold_evaluation = ( (convergence_regs_reset_n == 1'b1) && (cent_num == 3'd7) ) ? 1'b1 : 1'b0;

assign new_centroid_out = new_centroid_out_reg; 

//assign output has converged which indicates if the algorithm has ended
assign has_converged = check_convergence;
assign converge_res_available = converge_result_available_reg;



/*-------------FF LOGIC------------------*/

//new_centroid_out_reg
always @(negedge rst_n or posedge clk) begin
	if(rst_n==0) begin
		new_centroid_out_reg <= 4'b0;
	end
	else begin
		if (convergence_regs_reset_n==1'b0) begin
			new_centroid_out_reg <= 4'b0; 
		end
		else begin
			new_centroid_out_reg <= (divide_by_0==1'b1) ? old_centroid : new_centroid_in;
		end
	end
end


//convergence reg
always @(negedge rst_n or posedge clk) begin
	if(rst_n==0) begin
		convergence_reg <= 4'b0;
	end
	else begin
		if (convergence_regs_reset_n == 1'b0) begin
			convergence_reg <= 4'b0;
		end
		else if (convergence_reg_en) begin
			convergence_reg <= convergence_reg + under_thresh_hold;
		end
	end
end

//check_convergence - one clock after done_threshold_evaluation is true - therfore we need register
always @(negedge rst_n or posedge clk) begin
	if(rst_n==0) begin
		check_convergence <= 1'b0;
		converge_result_available_reg <= 1'b0;
	end
	else begin
		if (convergence_regs_reset_n == 1'b0) begin
			check_convergence <= 1'b0;
			converge_result_available_reg <= 1'b0;
		end
		else
			if(check_convergence==0) begin
				check_convergence <= done_threshold_evaluation ? (convergence_reg + under_thresh_hold == 4'd8) : 1'b0;//both values could be 0
			end
				
			converge_result_available_reg <= done_threshold_evaluation;//delay of clock - need to fix this to drop after controller sampled it
		
	end
end


























endmodule