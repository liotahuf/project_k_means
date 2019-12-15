/*------------------------------------------------------------------------------
 * File          : parsing_dividing_tb.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 6, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module parsing_dividing_tb #(
	tc_mode          = 0,
	rem_mode         =1,
	accum_width      = 7*22,
	addrWidth        = 8,
	dataWidth        = 91,
	centroid_num     =8,
	accum_cord_width = 22,
	cordinate_width  = 13,
	count_width      = 10
) ();

/*----------Instantiation------------*/
parsing_dividing parsing_dividing 
(
	 .accumulator(),
	 .counter(),
	//
	.result_cord_1(),
	.result_cord_2(),
	.result_cord_3(),
	.result_cord_4(),
	.result_cord_5(),
	.result_cord_6(),
	.result_cord_7()
);

/*------------ Wires------------*/

endmodule : parsing_dividing_tb