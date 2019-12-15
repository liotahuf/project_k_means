/*------------------------------------------------------------------------------
 * File          : flop_test.sv
 * Project       : MLProject
 * Author        : epedlh
 * Creation date : Sep 25, 2019
 * Description   :
 *------------------------------------------------------------------------------*/
module flop_test;
reg data, clock;
flop f1 (clock, data, qa
, 
qb);
initial
begin
clock = 0; data = 0;
#10000 $finish;
end
always #100 clock = ~clock;
always #300 data = ~data;
endmodule : flop_test