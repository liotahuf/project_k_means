/*------------------------------------------------------------------------------
 * File          : classification_block.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Oct 27, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module classification_block 
#(
	tc_mode         = 0,
	rem_mode        =1,
	accum_width = 7*22,
	addrWidth = 8,
	dataWidth = 91, 
	centroid_num =8,
	accum_cord_width = 22,
	cordinate_width = 13,
	count_width = 10
)
(
	
	input                      clk,
	input                      rst_n,
	input  [dataWidth-1:0]     data_from_ram,
	
	//controller interface
	input                      ram_input_reg_en,
	input  [centroid_num-1 :0] centroid_en,
	input                      accumulators_en,
	
	
	
	//k means core
	input  [dataWidth-1:0]     cen_reg1,
	input  [dataWidth-1:0]     cen_reg2,
	input  [dataWidth-1:0]     cen_reg3,
	input  [dataWidth-1:0]     cen_reg4,
	input  [dataWidth-1:0]     cen_reg5,
	input  [dataWidth-1:0]     cen_reg6,
	input  [dataWidth-1:0]     cen_reg7,
	input  [dataWidth-1:0]     cen_reg8,
	
	output [accum_width-1:0]   accum_1,
	output [accum_width-1:0]   accum_2,
	output [accum_width-1:0]   accum_3,
	output [accum_width-1:0]   accum_4,
	output [accum_width-1:0]   accum_5,
	output [accum_width-1:0]   accum_6,
	output [accum_width-1:0]   accum_7,
	output [accum_width-1:0]   accum_8,
	//
	output [count_width-1:0]   cnt_1,
	output [count_width-1:0]   cnt_2,
	output [count_width-1:0]   cnt_3,
	output [count_width-1:0]   cnt_4,
	output [count_width-1:0]   cnt_5,
	output [count_width-1:0]   cnt_6,
	output [count_width-1:0]   cnt_7,
	output [count_width-1:0]   cnt_8
);




/*----pipeline instances---*/



/*----Internal registers---*/




wire [dataWidth-1 :0]    distance_1;
wire [dataWidth-1 :0]    distance_2;
wire [dataWidth-1 :0]    distance_3;
wire [dataWidth-1 :0]    distance_4;
wire [dataWidth-1 :0]    distance_5;
wire [dataWidth-1 :0]    distance_6;
wire [dataWidth-1 :0]    distance_7;
wire [dataWidth-1 :0]    distance_8;
//pipe2 wrap
wire [3:0] index;
wire [dataWidth-1 :0] point_from_pipe_1_to_pipe_2;
//pipe3 wrap

wire [dataWidth-1 :0] point_from_pipe_2_to_pipe_3;
//



classify_block_pipe1 classify_block_pipe1 (
	.clk                 (clk                        ),
	.rst_n               (rst_n                      ),
	.centroid_en         (centroid_en                ),
	.centroid_reg_input_1(cen_reg1                   ),
	.centroid_reg_input_2(cen_reg2                   ),
	.centroid_reg_input_3(cen_reg3                   ),
	.centroid_reg_input_4(cen_reg4                   ),
	.centroid_reg_input_5(cen_reg5                   ),
	.centroid_reg_input_6(cen_reg6                   ),
	.centroid_reg_input_7(cen_reg7                   ),
	.centroid_reg_input_8(cen_reg8                   ),
	//
	.data_from_ram       (data_from_ram              ),
	.input_reg_en        (ram_input_reg_en           ),
	//
	.distance_1          (distance_1                 ),
	.distance_2          (distance_2                 ),
	.distance_3          (distance_3                 ),
	.distance_4          (distance_4                 ),
	.distance_5          (distance_5                 ),
	.distance_6          (distance_6                 ),
	.distance_7          (distance_7                 ),
	.distance_8          (distance_8                 ),
	.point_to_pipe2      (point_from_pipe_1_to_pipe_2)
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











endmodule : classification_block