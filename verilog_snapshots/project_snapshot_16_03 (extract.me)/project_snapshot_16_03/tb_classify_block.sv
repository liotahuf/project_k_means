/*------------------------------------------------------------------------------
 * File          : tb_classify_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 30, 2019
 * Description   :
 *------------------------------------------------------------------------------*/
//TODO: make this tb functional
module tb_classify_block #(
	addrWidth       = 8,
	dataWidth       = 91,
	centroid_num    =8,
	accum_width     =7*22,
	count_width     = 10,
	cordinate_width = 13
) ();

/*-----------regiters----------*/
reg clk;
reg rst_n;

//pipe1 wrap
reg [centroid_num-1 :0] centroid_enable;
reg [dataWidth-1:0] 	centroid_reg_input_1_tb;
reg [dataWidth-1:0] 	centroid_reg_input_2_tb;
reg [dataWidth-1:0] 	centroid_reg_input_3_tb;
reg [dataWidth-1:0] 	centroid_reg_input_4_tb;
reg [dataWidth-1:0] 	centroid_reg_input_5_tb;
reg [dataWidth-1:0] 	centroid_reg_input_6_tb;
reg [dataWidth-1:0] 	centroid_reg_input_7_tb;
reg [dataWidth-1:0] 	centroid_reg_input_8_tb;
//RAM-pipe1 wrap
reg [dataWidth-1 :0]	data_from_ram_tb;
reg input_reg_en;
//pipe1-pipe2 wrap
wire [dataWidth-1 :0]    distance_1_tb;
wire [dataWidth-1 :0]    distance_2_tb;
wire [dataWidth-1 :0]    distance_3_tb;
wire [dataWidth-1 :0]    distance_4_tb;
wire [dataWidth-1 :0]    distance_5_tb;
wire [dataWidth-1 :0]    distance_6_tb;
wire [dataWidth-1 :0]    distance_7_tb;
wire [dataWidth-1 :0]    distance_8_tb;
//pipe2 wrap
wire [3:0] index;
wire [dataWidth-1 :0] point_from_pipe_1_to_pipe_2;
//pipe3 wrap
reg enable_2_pipe3;
wire [dataWidth-1 :0] point_from_pipe_2_to_pipe_3;
//
wire [accum_width-1:0] accum_reg_1;
wire [accum_width-1:0] accum_reg_2;
wire [accum_width-1:0] accum_reg_3;
wire [accum_width-1:0] accum_reg_4;
wire [accum_width-1:0] accum_reg_5;
wire [accum_width-1:0] accum_reg_6;
wire [accum_width-1:0] accum_reg_7;
wire [accum_width-1:0] accum_reg_8;

wire [count_width-1:0] cnt_reg_1;
wire [count_width-1:0] cnt_reg_2;
wire [count_width-1:0] cnt_reg_3;
wire [count_width-1:0] cnt_reg_4;
wire [count_width-1:0] cnt_reg_5;
wire [count_width-1:0] cnt_reg_6;
wire [count_width-1:0] cnt_reg_7;
wire [count_width-1:0] cnt_reg_8;

/*classification_block classification_block (
	.clk             (clk                    ),
	.rst_n           (rst_n                  ),
	
	.data_from_ram   (data_from_ram_tb       ),
	.ram_input_reg_en(input_reg_en           ),
	.centroid_en     (centroid_enable        ),
	.accumulators_en (enable_2_pipe3         ),
	
	.cen_reg1        (centroid_reg_input_1_tb),
	.cen_reg2        (centroid_reg_input_2_tb),
	.cen_reg3        (centroid_reg_input_3_tb),
	.cen_reg4        (centroid_reg_input_4_tb),
	.cen_reg5        (centroid_reg_input_5_tb),
	.cen_reg6        (centroid_reg_input_6_tb),
	.cen_reg7        (centroid_reg_input_7_tb),
	.cen_reg8        (centroid_reg_input_8_tb),
	
	.accum_1         (accum_reg_1            ),
	.accum_2         (accum_reg_2            ),
	.accum_3         (accum_reg_3            ),
	.accum_4         (accum_reg_4            ),
	.accum_5         (accum_reg_5            ),
	.accum_6         (accum_reg_6            ),
	.accum_7         (accum_reg_7            ),
	.accum_8         (accum_reg_8            ),
	
	.cnt_1           (cnt_reg_1              ),
	.cnt_2           (cnt_reg_2              ),
	.cnt_3           (cnt_reg_3              ),
	.cnt_4           (cnt_reg_4              ),
	.cnt_5           (cnt_reg_5              ),
	.cnt_6           (cnt_reg_6              ),
	.cnt_7           (cnt_reg_7              ),
	.cnt_8           (cnt_reg_8              )
	

	
	
);*/

//classify_block_pipe1 classify_block_pipe1 (
//	.clk                 (clk                        ),
//	.rst_n               (rst_n                      ),
//	.centroid_en         (centroid_enable            ),
//	.centroid_reg_input_1(centroid_reg_input_1_tb    ),
//	.centroid_reg_input_2(centroid_reg_input_2_tb    ),
//	.centroid_reg_input_3(centroid_reg_input_3_tb    ),
//	.centroid_reg_input_4(centroid_reg_input_4_tb    ),
//	.centroid_reg_input_5(centroid_reg_input_5_tb    ),
//	.centroid_reg_input_6(centroid_reg_input_6_tb    ),
//	.centroid_reg_input_7(centroid_reg_input_7_tb    ),
//	.centroid_reg_input_8(centroid_reg_input_8_tb    ),
//	//
//	.data_from_ram       (data_from_ram_tb           ),
//	.input_reg_en        (input_reg_en               ),
//	//
//	.distance_1          (distance_1_tb              ),
//	.distance_2          (distance_2_tb              ),
//	.distance_3          (distance_3_tb              ),
//	.distance_4          (distance_4_tb              ),
//	.distance_5          (distance_5_tb              ),
//	.distance_6          (distance_6_tb              ),
//	.distance_7          (distance_7_tb              ),
//	.distance_8          (distance_8_tb              ),
//	.point_to_pipe2      (point_from_pipe_1_to_pipe_2)
//);
//
//classify_block_pipe2 classify_block_pipe2 (
//	.clk             (clk                        ),
//	.rst_n           (rst_n                      ),
//	.distance_1      (distance_1_tb              ),
//	.distance_2      (distance_2_tb              ),
//	.distance_3      (distance_3_tb              ),
//	.distance_4      (distance_4_tb              ),
//	.distance_5      (distance_5_tb              ),
//	.distance_6      (distance_6_tb              ),
//	.distance_7      (distance_7_tb              ),
//	.distance_8      (distance_8_tb              ),
//	.index           (index                      ),
//	.point_from_pipe1(point_from_pipe_1_to_pipe_2),
//	.point_to_pipe3  (point_from_pipe_2_to_pipe_3)
//);
//
//classify_block_pipe3 classify_block_pipe3 (
//	.clk          (clk                        ),
//	.rst_n        (rst_n                      ),
//	.index        (index                      ),
//	.point        (point_from_pipe_2_to_pipe_3),
//	.enable_2_regs(enable_2_pipe3             ),
//	.accum_reg_1  (accum_reg_1                ),
//	.accum_reg_2  (accum_reg_2                ),
//	.accum_reg_3  (accum_reg_3                ),
//	.accum_reg_4  (accum_reg_4                ),
//	.accum_reg_5  (accum_reg_5                ),
//	.accum_reg_6  (accum_reg_6                ),
//	.accum_reg_7  (accum_reg_7                ),
//	.accum_reg_8  (accum_reg_8                ),
//	.cnt_reg_1    (cnt_reg_1                  ),
//	.cnt_reg_2    (cnt_reg_2                  ),
//	.cnt_reg_3    (cnt_reg_3                  ),
//	.cnt_reg_4    (cnt_reg_4                  ),
//	.cnt_reg_5    (cnt_reg_5                  ),
//	.cnt_reg_6    (cnt_reg_6                  ),
//	.cnt_reg_7    (cnt_reg_7                  ),
//	.cnt_reg_8    (cnt_reg_8                  )
//);

//-----------------------------------------
//			Test pattern
//-----------------------------------------
initial begin
	initiate_all;
	#10
			write_centroid(0);
	//#10
	write_centroid(1);
	//#10
	write_centroid(2);
	//#10
	write_centroid(3);
	//	#10
	write_centroid(4);
	//	#10
	write_centroid (5);
	//	#10
	write_centroid(6);
	//	#10
	write_centroid(7);
	//	#10
	
	input_new_data(91'b1);
	input_new_data(91'd2);
	enable_accumulators;
	input_new_data(91'd3);
	
	#100
			$finish;
end


//-----------------------------------------
//			Clock generator
//-----------------------------------------

always
	#5 clk = ~clk;

task initiate_all;
	begin
		clk = 1'b1;
		rst_n = 1'b0;
		centroid_enable = 0;
		centroid_reg_input_1_tb = 1;
		centroid_reg_input_2_tb = 2;
		centroid_reg_input_3_tb = 3;
		centroid_reg_input_4_tb = 4;
		centroid_reg_input_5_tb = 5;
		centroid_reg_input_6_tb = 6;
		centroid_reg_input_7_tb = 7;
		centroid_reg_input_8_tb = 8;
		
		centroid_reg_input_1_tb[2*cordinate_width -1:cordinate_width] = 1;
		centroid_reg_input_2_tb[2*cordinate_width -1:cordinate_width] = 2;
		centroid_reg_input_3_tb[2*cordinate_width -1:cordinate_width] = 3;
		centroid_reg_input_4_tb[2*cordinate_width -1:cordinate_width] = 4;
		centroid_reg_input_5_tb[2*cordinate_width -1:cordinate_width] = 5;
		centroid_reg_input_6_tb[2*cordinate_width -1:cordinate_width] = 6;
		centroid_reg_input_7_tb[2*cordinate_width -1:cordinate_width] = 7;
		centroid_reg_input_8_tb[2*cordinate_width -1:cordinate_width] = 0;
		
		
		data_from_ram_tb =91'd10;
		
		#5 rst_n = 1'b1;
	end
endtask

task write_centroid;
	input [centroid_num-1 :0] centroid_reg_num;
	centroid_enable[centroid_reg_num] =1;
	#10
			centroid_enable[centroid_reg_num] =0;
endtask

task input_new_data;
	input [dataWidth-1 :0] new_data;
	input_reg_en =1;
	#10
			//			input_reg_en =0;
			data_from_ram_tb =new_data;
endtask

task enable_accumulators;
	enable_2_pipe3 =1;
	
endtask


endmodule : tb_classify_block