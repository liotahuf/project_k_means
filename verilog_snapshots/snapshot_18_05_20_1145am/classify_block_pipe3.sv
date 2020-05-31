/*------------------------------------------------------------------------------
 * File          : classify_block_pipe3.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classify_block_pipe3 #(
	parameter
	tc_mode          = 0,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10
) (
	input                    clk,
	input                    rst_n,
	
	//classify block pipe2 IF
	input  [3:0]             index,
	input  [dataWidth-1:0]   point,
	input                    enable_2_regs,
	
	//classification block IF(from controller)
	input                    regs_reset_n,
	///
	output [accum_width-1:0] accum_reg_1,
	output [accum_width-1:0] accum_reg_2,
	output [accum_width-1:0] accum_reg_3,
	output [accum_width-1:0] accum_reg_4,
	output [accum_width-1:0] accum_reg_5,
	output [accum_width-1:0] accum_reg_6,
	output [accum_width-1:0] accum_reg_7,
	output [accum_width-1:0] accum_reg_8,
	///
	output [count_width-1:0] cnt_reg_1,
	output [count_width-1:0] cnt_reg_2,
	output [count_width-1:0] cnt_reg_3,
	output [count_width-1:0] cnt_reg_4,
	output [count_width-1:0] cnt_reg_5,
	output [count_width-1:0] cnt_reg_6,
	output [count_width-1:0] cnt_reg_7,
	output [count_width-1:0] cnt_reg_8
	
);


/*----Registers----*/

//accumlator registers
reg [accum_width-1:0] accumulator_reg_1;
reg [accum_width-1:0] accumulator_reg_2;
reg [accum_width-1:0] accumulator_reg_3;
reg [accum_width-1:0] accumulator_reg_4;
reg [accum_width-1:0] accumulator_reg_5;
reg [accum_width-1:0] accumulator_reg_6;
reg [accum_width-1:0] accumulator_reg_7;
reg [accum_width-1:0] accumulator_reg_8;

//counter registers
reg [dataWidth-1:0] counter_reg_1;
reg [dataWidth-1:0] counter_reg_2;
reg [dataWidth-1:0] counter_reg_3;
reg [dataWidth-1:0] counter_reg_4;
reg [dataWidth-1:0] counter_reg_5;
reg [dataWidth-1:0] counter_reg_6;
reg [dataWidth-1:0] counter_reg_7;
reg [dataWidth-1:0] counter_reg_8;


/*----Wires----*/

//wires related accumulator registers
wire [dataWidth-1:0] demux_accum_1;
wire [dataWidth-1:0] demux_accum_2;
wire [dataWidth-1:0] demux_accum_3;
wire [dataWidth-1:0] demux_accum_4;
wire [dataWidth-1:0] demux_accum_5;
wire [dataWidth-1:0] demux_accum_6;
wire [dataWidth-1:0] demux_accum_7;
wire [dataWidth-1:0] demux_accum_8;

//wires related counter registers
wire [dataWidth-1:0] demux_cnt_1;
wire [dataWidth-1:0] demux_cnt_2;
wire [dataWidth-1:0] demux_cnt_3;
wire [dataWidth-1:0] demux_cnt_4;
wire [dataWidth-1:0] demux_cnt_5;
wire [dataWidth-1:0] demux_cnt_6;
wire [dataWidth-1:0] demux_cnt_7;
wire [dataWidth-1:0] demux_cnt_8;

//wires for result of accum_adder's
wire [accum_width-1:0] result_cent_1;
wire [accum_width-1:0] result_cent_2;
wire [accum_width-1:0] result_cent_3;
wire [accum_width-1:0] result_cent_4;
wire [accum_width-1:0] result_cent_5;
wire [accum_width-1:0] result_cent_6;
wire [accum_width-1:0] result_cent_7;
wire [accum_width-1:0] result_cent_8;

/*----comb logic----*/
assign accum_reg_1 = accumulator_reg_1;
assign accum_reg_2 = accumulator_reg_2;
assign accum_reg_3 = accumulator_reg_3;
assign accum_reg_4 = accumulator_reg_4;
assign accum_reg_5 = accumulator_reg_5;
assign accum_reg_6 = accumulator_reg_6;
assign accum_reg_7 = accumulator_reg_7;
assign accum_reg_8 = accumulator_reg_8;
//
assign cnt_reg_1 = counter_reg_1;
assign cnt_reg_2 = counter_reg_2;
assign cnt_reg_3 = counter_reg_3;
assign cnt_reg_4 = counter_reg_4;
assign cnt_reg_5 = counter_reg_5;
assign cnt_reg_6 = counter_reg_6;
assign cnt_reg_7 = counter_reg_7;
assign cnt_reg_8 = counter_reg_8;

/*-------Instantiation---------*/
demux demux_accumulators (
	.data_in   (point        ),
	.index     (index        ),
	.data_out_1(demux_accum_1),
	.data_out_2(demux_accum_2),
	.data_out_3(demux_accum_3),
	.data_out_4(demux_accum_4),
	.data_out_5(demux_accum_5),
	.data_out_6(demux_accum_6),
	.data_out_7(demux_accum_7),
	.data_out_8(demux_accum_8)
);
demux demux_counters (
	.data_in   (91'b1      ),
	.index     (index      ),
	.data_out_1(demux_cnt_1),
	.data_out_2(demux_cnt_2),
	.data_out_3(demux_cnt_3),
	.data_out_4(demux_cnt_4),
	.data_out_5(demux_cnt_5),
	.data_out_6(demux_cnt_6),
	.data_out_7(demux_cnt_7),
	.data_out_8(demux_cnt_8)
);

accumulator_adder adder1 (
	.point      (demux_accum_1    ),
	.accumulator(accumulator_reg_1),
	.result     (result_cent_1    )
);
accumulator_adder adder2 (
	.point      (demux_accum_2    ),
	.accumulator(accumulator_reg_2),
	.result     (result_cent_2    )
);
accumulator_adder adder3 (
	.point      (demux_accum_3    ),
	.accumulator(accumulator_reg_3),
	.result     (result_cent_3    )
);
accumulator_adder adder4 (
	.point      (demux_accum_4    ),
	.accumulator(accumulator_reg_4),
	.result     (result_cent_4    )
);
accumulator_adder adder5 (
	.point      (demux_accum_5    ),
	.accumulator(accumulator_reg_5),
	.result     (result_cent_5    )
);
accumulator_adder adder6 (
	.point      (demux_accum_6    ),
	.accumulator(accumulator_reg_6),
	.result     (result_cent_6    )
);
accumulator_adder adder7 (
	.point      (demux_accum_7    ),
	.accumulator(accumulator_reg_7),
	.result     (result_cent_7    )
);
accumulator_adder adder8 (
	.point      (demux_accum_8    ),
	.accumulator(accumulator_reg_8),
	.result     (result_cent_8    )
);

/*----flipflop logic----*/

//counter registers update
always @(negedge rst_n or posedge clk) begin
	if (rst_n==0) begin
		counter_reg_1 <= 0;
		counter_reg_2 <= 0;
		counter_reg_3 <= 0;
		counter_reg_4 <= 0;
		counter_reg_5 <= 0;
		counter_reg_6 <= 0;
		counter_reg_7 <= 0;
		counter_reg_8 <= 0;
	end
	else begin
		if(enable_2_regs ==1'b1) begin
			counter_reg_1 <=counter_reg_1 + demux_cnt_1;
			counter_reg_2 <=counter_reg_2 + demux_cnt_2;
			counter_reg_3 <=counter_reg_3 + demux_cnt_3;
			counter_reg_4 <=counter_reg_4 + demux_cnt_4;
			counter_reg_5 <=counter_reg_5 + demux_cnt_5;
			counter_reg_6 <=counter_reg_6 + demux_cnt_6;
			counter_reg_7 <=counter_reg_7 + demux_cnt_7;
			counter_reg_8 <=counter_reg_8 + demux_cnt_8;
		end
		
		if(regs_reset_n == 1'b0) begin
			counter_reg_1 <= 0;
			counter_reg_2 <= 0;
			counter_reg_3 <= 0;
			counter_reg_4 <= 0;
			counter_reg_5 <= 0;
			counter_reg_6 <= 0;
			counter_reg_7 <= 0;
			counter_reg_8 <= 0;
		end
		
	end
end

//accumulator registers update
always @(negedge rst_n or posedge clk) begin
	if (rst_n==0) begin
		accumulator_reg_1 <= 0;
		accumulator_reg_2 <= 0;
		accumulator_reg_3 <= 0;
		accumulator_reg_4 <= 0;
		accumulator_reg_5 <= 0;
		accumulator_reg_6 <= 0;
		accumulator_reg_7 <= 0;
		accumulator_reg_8 <= 0;
	end
	else begin
		if(enable_2_regs ==1'b1) begin
			accumulator_reg_1 <= result_cent_1;
			accumulator_reg_2 <= result_cent_2;
			accumulator_reg_3 <= result_cent_3;
			accumulator_reg_4 <= result_cent_4;
			accumulator_reg_5 <= result_cent_5;
			accumulator_reg_6 <= result_cent_6;
			accumulator_reg_7 <= result_cent_7;
			accumulator_reg_8 <= result_cent_8;
		end
		
		if(regs_reset_n == 1'b0) begin
			accumulator_reg_1 <= 0;
			accumulator_reg_2 <= 0;
			accumulator_reg_3 <= 0;
			accumulator_reg_4 <= 0;
			accumulator_reg_5 <= 0;
			accumulator_reg_6 <= 0;
			accumulator_reg_7 <= 0;
			accumulator_reg_8 <= 0;
		end
	end
end





endmodule