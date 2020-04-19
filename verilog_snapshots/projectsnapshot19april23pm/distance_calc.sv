/*------------------------------------------------------------------------------
 * File          : distance_calc.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Nov 3, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module distance_calc
#(
	parameter
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
	input [dataWidth-1:0]  first_point,
	input [dataWidth-1:0]  second_point,
	//
	output [dataWidth-1:0]	distance
);

/*-----Wires-----*/

//first point
wire [cordinate_width -1:0] first_point_cord_1;
wire [cordinate_width -1:0] first_point_cord_2;
wire [cordinate_width -1:0] first_point_cord_3;
wire [cordinate_width -1:0] first_point_cord_4;
wire [cordinate_width -1:0] first_point_cord_5;
wire [cordinate_width -1:0] first_point_cord_6;
wire [cordinate_width -1:0] first_point_cord_7;

//second point
wire [cordinate_width -1:0] second_point_cord_1;
wire [cordinate_width -1:0] second_point_cord_2;
wire [cordinate_width -1:0] second_point_cord_3;
wire [cordinate_width -1:0] second_point_cord_4;
wire [cordinate_width -1:0] second_point_cord_5;
wire [cordinate_width -1:0] second_point_cord_6;
wire [cordinate_width -1:0] second_point_cord_7;

//per_cordinate_dist
wire [cordinate_width -1:0] cord_1_dist;
wire [cordinate_width -1:0] cord_2_dist;
wire [cordinate_width -1:0] cord_3_dist;
wire [cordinate_width -1:0] cord_4_dist;
wire [cordinate_width -1:0] cord_5_dist;
wire [cordinate_width -1:0] cord_6_dist;
wire [cordinate_width -1:0] cord_7_dist;

//wire assigns
assign first_point_cord_1 = first_point[cordinate_width -1:0];
assign first_point_cord_2 = first_point[2*cordinate_width -1:cordinate_width];
assign first_point_cord_3 = first_point[3*cordinate_width -1:2*cordinate_width];
assign first_point_cord_4 = first_point[4*cordinate_width -1:3*cordinate_width];
assign first_point_cord_5 = first_point[5*cordinate_width -1:4*cordinate_width];
assign first_point_cord_6 = first_point[6*cordinate_width -1:5*cordinate_width];
assign first_point_cord_7 = first_point[7*cordinate_width -1:6*cordinate_width];


assign second_point_cord_1 = second_point[cordinate_width -1:0];
assign second_point_cord_2 = second_point[2*cordinate_width -1:cordinate_width];
assign second_point_cord_3 = second_point[3*cordinate_width -1:2*cordinate_width];
assign second_point_cord_4 = second_point[4*cordinate_width -1:3*cordinate_width];
assign second_point_cord_5 = second_point[5*cordinate_width -1:4*cordinate_width];
assign second_point_cord_6 = second_point[6*cordinate_width -1:5*cordinate_width];
assign second_point_cord_7 = second_point[7*cordinate_width -1:6*cordinate_width];


/*----comb logic----*/
assign cord_1_dist = (first_point_cord_1 > second_point_cord_1) ?  (first_point_cord_1 - second_point_cord_1) : (second_point_cord_1 - first_point_cord_1);
assign cord_2_dist = (first_point_cord_2 > second_point_cord_2) ?  (first_point_cord_2 - second_point_cord_2) : (second_point_cord_2 - first_point_cord_2);
assign cord_3_dist = (first_point_cord_3 > second_point_cord_3) ?  (first_point_cord_3 - second_point_cord_3) : (second_point_cord_3 - first_point_cord_3);
assign cord_4_dist = (first_point_cord_4 > second_point_cord_4) ?  (first_point_cord_4 - second_point_cord_4) : (second_point_cord_4 - first_point_cord_4);
assign cord_5_dist = (first_point_cord_5 > second_point_cord_5) ?  (first_point_cord_5 - second_point_cord_5) : (second_point_cord_5 - first_point_cord_5);
assign cord_6_dist = (first_point_cord_6 > second_point_cord_6) ?  (first_point_cord_6 - second_point_cord_6) : (second_point_cord_6 - first_point_cord_6);
assign cord_7_dist = (first_point_cord_7 > second_point_cord_7) ?  (first_point_cord_7 - second_point_cord_7) : (second_point_cord_7 - first_point_cord_7);
//
assign distance = cord_1_dist + cord_2_dist + cord_3_dist + cord_4_dist + cord_5_dist + cord_6_dist + cord_7_dist; 



endmodule