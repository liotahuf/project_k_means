/*------------------------------------------------------------------------------
 * File          : flop.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Sep 25, 2019
 * Description   :
 *------------------------------------------------------------------------------*/

module flop (clock, data, qa, qb);
input clock,data;
output qa, qb;

nand #10 nd1 (a, data, clock),
nd2 (b, ndata,clock),
nd3 (qa, a, qb),
nd4 (qb, b,qa);
mynot nt1 (ndata, data);
endmodule


module mynot (out, in);
output out;
input in;
not(out,in);
endmodule