/*------------------------------------------------------------------------------
 * File          : tb_new_means_calculation.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 10, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module tb_new_means_calculation #(
	tc_mode          = 1,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10
) ();


/*---------WIRES--------*/
reg clk;
reg rst_n;
//
reg  [accum_width-1:0] accum_1;
reg  [accum_width-1:0] accum_2;
reg  [accum_width-1:0] accum_3;
reg  [accum_width-1:0] accum_4;
reg  [accum_width-1:0] accum_5;
reg  [accum_width-1:0] accum_6;
reg  [accum_width-1:0] accum_7;
reg  [accum_width-1:0] accum_8;
//
reg  [count_width-1:0] cnt_1;
reg  [count_width-1:0] cnt_2;
reg  [count_width-1:0] cnt_3;
reg  [count_width-1:0] cnt_4;
reg  [count_width-1:0] cnt_5;
reg  [count_width-1:0] cnt_6;
reg  [count_width-1:0] cnt_7;
reg  [count_width-1:0] cnt_8;
//
wire [accum_cord_width-1:0 ] result_cord_1;
wire [accum_cord_width-1:0 ] result_cord_2;
wire [accum_cord_width-1:0 ] result_cord_3;
wire [accum_cord_width-1:0 ] result_cord_4;
wire [accum_cord_width-1:0 ] result_cord_5;
wire [accum_cord_width-1:0 ] result_cord_6;
wire [accum_cord_width-1:0 ] result_cord_7;
wire [dataWidth-1:0]		 new_centroid;
//
wire divide_by_0;
//
reg [2:0] cent_cnt;
reg divider_en;


/*----------Instantiation------------*/
new_means_calculation_block new_means_calculation_block (
	.clk         (clk         ),
	.rst_n       (rst_n       ),
	//
	.accum_1     (accum_1     ),
	.accum_2     (accum_2     ),
	.accum_3     (accum_3     ),
	.accum_4     (accum_4     ),
	.accum_5     (accum_5     ),
	.accum_6     (accum_6     ),
	.accum_7     (accum_7     ),
	.accum_8     (accum_8     ),
	//
	.cnt_1       (cnt_1       ),
	.cnt_2       (cnt_2       ),
	.cnt_3       (cnt_3       ),
	.cnt_4       (cnt_4       ),
	.cnt_5       (cnt_5       ),
	.cnt_6       (cnt_6       ),
	.cnt_7       (cnt_7       ),
	.cnt_8       (cnt_8       ),
	//controller interface
	.cent_cnt    (cent_cnt    ),
	.divider_en  (divider_en  ),
	.divide_by_0 (divide_by_0 ),
	.new_centroid(new_centroid)
);


//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;



task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		//
		accum_1 = 154'b0;
		accum_2 = 154'b0;
		accum_3 = 154'b0;
		accum_4 = 154'b0;
		accum_5 = 154'b0;
		accum_6 = 154'b0;
		accum_7 = 154'b0;
		accum_8 = 154'b0;
		//
		cnt_1 = 10'b0;
		cnt_2 = 10'b0;
		cnt_3 = 10'b0;
		cnt_4 = 10'b0;
		cnt_5 = 10'b0;
		cnt_6 = 10'b0;
		cnt_7 = 10'b0;
		cnt_8 = 10'b0;
		//
		cent_cnt = 3'b0;
		divider_en = 1'b0;
		
		
		#2.5 rst_n = 1'b1;
	end
endtask

task set_inputs;
	input [accum_width-1 :0] dividend;
	input [count_width-1 :0] divisor;
	input [2:0]				 cent_cnt;
	begin
		case (cent_cnt)
			3'd0 : begin
				accum_1 = dividend;
				cnt_1 = divisor;
			end
			3'd1 : begin
				accum_2 = dividend;
				cnt_2 = divisor;
			end
			3'd2 : begin
				accum_3 = dividend;
				cnt_3 = divisor;
			end
			3'd3 : begin
				accum_4 = dividend;
				cnt_4 = divisor;
			end
			3'd4 : begin
				accum_5 = dividend;
				cnt_5 = divisor;
			end
			3'd5 : begin
				accum_6 = dividend;
				cnt_6 = divisor;
			end
			3'd6 : begin
				accum_7 = dividend;
				cnt_7 = divisor;
			end
			3'd7 : begin
				accum_8 = dividend;
				cnt_8 = divisor;
			end
		endcase
	end
	
endtask
task calculate_new_cent;
	input [2:0] cent_num_in;
	cent_cnt=cent_num_in;
	divider_en=1;
	
endtask

//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	initiate_all;
	#10
			set_inputs({132'b0,9'b0,4'b0111,9'b0},10'd2,3'b0);
	#10
			set_inputs({132'b0,9'b0,4'b0011,9'b0},10'd3,3'b1);
	#10
			set_inputs({132'b0,11'b0,11'b11010011101},10'd13,3'd2);//result is 0.1270 = {14'b0,10000010}
	#10
			set_inputs({88'b0,22'b1111111111110001110101,22'b0,22'b1111111111101000001000},10'd11,3'd3);//result is 1111 1111 1111 1111 0101 110
	#10
			calculate_new_cent(3'd2);
	#10
			calculate_new_cent(3'd1);
	#10
			calculate_new_cent(3'd3);
	#10
			calculate_new_cent(3'd0);
	#10
			$finish;
end







endmodule : tb_new_means_calculation