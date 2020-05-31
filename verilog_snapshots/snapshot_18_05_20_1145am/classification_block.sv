/*------------------------------------------------------------------------------
 * File          : classification_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classification_block #(
	parameter
	tc_mode          = 0,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10,
	reg_amount       =4
) (
	
	input                      clk,
	input                      rst_n,
	input  [dataWidth-1:0]     data_from_ram,
	
	//controller interface
	input                      ram_input_reg_en,
	input  [centroid_num-1 :0] centroid_en,
	input                      accumulators_en,
	input                      pipe3_regs_reset_n, //for pipe3
	input                      first_iteration,
	
	
	//k means core
	//
	input  [dataWidth-1:0]     data_from_regfile,
	//output [dataWidth-1:0]     data_to_regfile, - eddy rmv 21.4.20
	//centroid_reg1
	
	//IF with new means calculation block
	output [accum_width-1:0]   accum_1,
	output [accum_width-1:0]   accum_2,
	output [accum_width-1:0]   accum_3,
	output [accum_width-1:0]   accum_4,
	output [accum_width-1:0]   accum_5,
	output [accum_width-1:0]   accum_6,
	output [accum_width-1:0]   accum_7,
	output [accum_width-1:0]   accum_8,
	///
	output [count_width-1:0]   cnt_1,
	output [count_width-1:0]   cnt_2,
	output [count_width-1:0]   cnt_3,
	output [count_width-1:0]   cnt_4,
	output [count_width-1:0]   cnt_5,
	output [count_width-1:0]   cnt_6,
	output [count_width-1:0]   cnt_7,
	output [count_width-1:0]   cnt_8,
	
	//IF with convergence check block, and with k-means-core - fan out to both of them
	output [dataWidth-1:0]     centroid_reg_1,
	output [dataWidth-1:0]     centroid_reg_2,
	output [dataWidth-1:0]     centroid_reg_3,
	output [dataWidth-1:0]     centroid_reg_4,
	output [dataWidth-1:0]     centroid_reg_5,
	output [dataWidth-1:0]     centroid_reg_6,
	output [dataWidth-1:0]     centroid_reg_7,
	output [dataWidth-1:0]     centroid_reg_8,
	///
	input  [2:0]               cent_cnt,
	input  [dataWidth-1:0]     new_centroid
);




/*----pipeline instances---*/



/*----Internal registers---*/



//pipe1 wrap
wire [dataWidth-1 :0]    distance_1;
wire [dataWidth-1 :0]    distance_2;
wire [dataWidth-1 :0]    distance_3;
wire [dataWidth-1 :0]    distance_4;
wire [dataWidth-1 :0]    distance_5;
wire [dataWidth-1 :0]    distance_6;
wire [dataWidth-1 :0]    distance_7;
wire [dataWidth-1 :0]    distance_8;
///



//pipe2 wrap
wire [3:0] index;
wire [dataWidth-1 :0] point_from_pipe_1_to_pipe_2;
//pipe3 wrap
wire [dataWidth-1 :0] point_from_pipe_2_to_pipe_3;



classify_block_pipe1 classify_block_pipe1 (
	.clk                     (clk                        ),
	.rst_n                   (rst_n                      ),
	.centroid_en             (centroid_en                ),
	.first_iteration         (first_iteration            ),
	.centroid_input_from_core(data_from_regfile          ),
	//.centroid_output_to_core  (data_to_regfile            ), - eddy rmv 21.4.20
	//
	.data_from_ram           (data_from_ram              ),
	.input_reg_en            (ram_input_reg_en           ),
	//
	.distance_1              (distance_1                 ),
	.distance_2              (distance_2                 ),
	.distance_3              (distance_3                 ),
	.distance_4              (distance_4                 ),
	.distance_5              (distance_5                 ),
	.distance_6              (distance_6                 ),
	.distance_7              (distance_7                 ),
	.distance_8              (distance_8                 ),
	.point_to_pipe2          (point_from_pipe_1_to_pipe_2),
	
	//convergence check block send/recieve centroids
	.cent_cnt                (cent_cnt                   ),
	.new_centroid            (new_centroid               ),
	.centroid_reg_output_1   (centroid_reg_1             ),
	.centroid_reg_output_2   (centroid_reg_2             ),
	.centroid_reg_output_3   (centroid_reg_3             ),
	.centroid_reg_output_4   (centroid_reg_4             ),
	.centroid_reg_output_5   (centroid_reg_5             ),
	.centroid_reg_output_6   (centroid_reg_6             ),
	.centroid_reg_output_7   (centroid_reg_7             ),
	.centroid_reg_output_8   (centroid_reg_8             )
);

classify_block_pipe2 classify_block_pipe2 (
	.clk             (clk                        ),
	.rst_n           (rst_n                      ),
	.distance_1      (distance_1                 ),
	.distance_2      (distance_2                 ),
	.distance_3      (distance_3                 ),
	.distance_4      (distance_4                 ),
	.distance_5      (distance_5                 ),
	.distance_6      (distance_6                 ),
	.distance_7      (distance_7                 ),
	.distance_8      (distance_8                 ),
	.index           (index                      ),
	.point_from_pipe1(point_from_pipe_1_to_pipe_2),
	.point_to_pipe3  (point_from_pipe_2_to_pipe_3)
);

classify_block_pipe3 classify_block_pipe3 (
	.clk          (clk                        ),
	.rst_n        (rst_n                      ),
	.index        (index                      ),
	.point        (point_from_pipe_2_to_pipe_3),
	.enable_2_regs(accumulators_en            ),
	.regs_reset_n (pipe3_regs_reset_n         ),
	.accum_reg_1  (accum_1                    ),
	.accum_reg_2  (accum_2                    ),
	.accum_reg_3  (accum_3                    ),
	.accum_reg_4  (accum_4                    ),
	.accum_reg_5  (accum_5                    ),
	.accum_reg_6  (accum_6                    ),
	.accum_reg_7  (accum_7                    ),
	.accum_reg_8  (accum_8                    ),
	.cnt_reg_1    (cnt_1                      ),
	.cnt_reg_2    (cnt_2                      ),
	.cnt_reg_3    (cnt_3                      ),
	.cnt_reg_4    (cnt_4                      ),
	.cnt_reg_5    (cnt_5                      ),
	.cnt_reg_6    (cnt_6                      ),
	.cnt_reg_7    (cnt_7                      ),
	.cnt_reg_8    (cnt_8                      )
);











endmodule