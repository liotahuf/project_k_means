//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (c) 2003 Synopsys, Inc.  All Rights Reserved       //
// This information is provided pursuant to a license agreement //
// that grants limited rights of access/use and requires that   //
// the information be treated as confidential.                  //
//                                                              //
//////////////////////////////////////////////////////////////////
//----------------------Revision History--------------------------------------
// 21-Dec-99,  1.0, Philippe Mahe, Preliminary version
// 20-Jan-00,  1.1, Philippe Mahe, Change noedge violation on constraint pin
//                                 by a posedge & a negedge violations.
// 10-May-00,  1.2, Philippe Mahe, Remove sdf define.
// 18-Aug-00,  1.3, Philippe Mahe, Invert tLBA and tHBA timing (ba en|disable).
//                                 Distinguish rise and fall constraint setup
//                                 time for CSB and WEB.
//                                 Modify WENB violation result by taking care
//                                 of the state of WEB at the active edge clock.
//                                 Modify BA violation result (D/E #21410).
//----------------------------------------------------------------------------

`timescale 1ns/1fs


`define numAddr 9          
`define numOut 50 
`define wordDepth 512

`define verbose 3
`ifdef verbose_0
`undef verbose
`define verbose 0
`endif
`ifdef verbose_1
`undef verbose
`define  verbose 1
`endif
`ifdef verbose_2
`undef verbose
`define verbose 2
`endif
`ifdef verbose_3
`undef verbose
`define verbose 3
`endif

`ifdef POLARIS_CBS
`define mintimestep
`else
`define mintimestep #0.01
`endif

`celldefine
module spram512x50_cb(A,CEB,WEB, OEB, CSB,
                    I,O);

`ifdef nobanner

`else
initial
begin
  $display("        SYNCHRONOUS RAM VERILOG BEHAVIOURAL MODEL	 		");
  $display("									");
  $display("                  Synopsys, Inc.                                    ");
  $display("                  46871 Bayside Parkway				");
  $display("                  Fremont CA 94538					");
  $display("							 		");
  $display("                  Rev 3.0 Oct. 2003       		 		");
  $display("							 		");
  $display(" Polaris INFO : Reccommending to use with +ieee +defparam +pulse_x/0");
  $display("                +pulse_r/0 +pathpulse +define+verbose_<X> options   ");
  $display("									");
  $display(" Error filtering options description : 			 	");
  $display(" +define+verbose_0 : X transitions filtered; no messages printed    ");
  $display(" +define+verbose_1 : X transitions filtered; error messages printed	");
  $display(" +define+verbose_2 : no X transtions filtering; no messages printed	");
  $display(" +define+verbose_3 : default : no X filtering; err messages printed ");
  $display("									");
  $display(" Add +define+nobanner in order not to display these header messages ");
  $display("								 	");
if (`verbose == 0 || `verbose == 1)
begin
  $display("								 	");
  $display(" THIS VERBOSE LEVEL MAY PRODUCE MIS-USAGE OF THE MEMORY BECAUSE :   ");
  $display(" - A TIMING ERROR DOES NOT INVALIDATE THE READ/WRITE OPEARTION AND 	");
  $display("   MAY KEEP THE ALREADY AVAILABLE DATA.				");
  $display(" - TRANSITION TO/FROM HIGH-Z/LOW-Z MAY SHOW DIFFERENT TIMINGS AS	");
  $display("   COMPARED TO AN HIGHER VERBOSE LEVEL			 	");
  $display("								 	");
end
end
`endif

input [`numAddr-1:0] A;
wire [`numAddr-1:0] A, a_state;
buf
    (a_state[8],A[8]),
    (a_state[7],A[7]),
    (a_state[6],A[6]),
    (a_state[5],A[5]),
    (a_state[4],A[4]),
    (a_state[3],A[3]),
    (a_state[2],A[2]),
    (a_state[1],A[1]),
    (a_state[0],A[0]);
input CEB,WEB, OEB, CSB;
buf (ck_state,CEB);
buf (web_state,WEB);
buf (oeb_state,OEB);
buf (csb_state,CSB);

input [`numOut-1:0] I;
output [`numOut-1:0] O;
wire [`numOut-1:0] I,O,i_state,o_state;
buf
    (i_state[49],I[49]),
    (i_state[48],I[48]),
    (i_state[47],I[47]),
    (i_state[46],I[46]),
    (i_state[45],I[45]),
    (i_state[44],I[44]),
    (i_state[43],I[43]),
    (i_state[42],I[42]),
    (i_state[41],I[41]),
    (i_state[40],I[40]),
    (i_state[39],I[39]),
    (i_state[38],I[38]),
    (i_state[37],I[37]),
    (i_state[36],I[36]),
    (i_state[35],I[35]),
    (i_state[34],I[34]),
    (i_state[33],I[33]),
    (i_state[32],I[32]),
    (i_state[31],I[31]),
    (i_state[30],I[30]),
    (i_state[29],I[29]),
    (i_state[28],I[28]),
    (i_state[27],I[27]),
    (i_state[26],I[26]),
    (i_state[25],I[25]),
    (i_state[24],I[24]),
    (i_state[23],I[23]),
    (i_state[22],I[22]),
    (i_state[21],I[21]),
    (i_state[20],I[20]),
    (i_state[19],I[19]),
    (i_state[18],I[18]),
    (i_state[17],I[17]),
    (i_state[16],I[16]),
    (i_state[15],I[15]),
    (i_state[14],I[14]),
    (i_state[13],I[13]),
    (i_state[12],I[12]),
    (i_state[11],I[11]),
    (i_state[10],I[10]),
    (i_state[9],I[9]),
    (i_state[8],I[8]),
    (i_state[7],I[7]),
    (i_state[6],I[6]),
    (i_state[5],I[5]),
    (i_state[4],I[4]),
    (i_state[3],I[3]),
    (i_state[2],I[2]),
    (i_state[1],I[1]),
    (i_state[0],I[0]);
bufif1
       (O[49],o_state[49],enable),
       (O[48],o_state[48],enable),
       (O[47],o_state[47],enable),
       (O[46],o_state[46],enable),
       (O[45],o_state[45],enable),
       (O[44],o_state[44],enable),
       (O[43],o_state[43],enable),
       (O[42],o_state[42],enable),
       (O[41],o_state[41],enable),
       (O[40],o_state[40],enable),
       (O[39],o_state[39],enable),
       (O[38],o_state[38],enable),
       (O[37],o_state[37],enable),
       (O[36],o_state[36],enable),
       (O[35],o_state[35],enable),
       (O[34],o_state[34],enable),
       (O[33],o_state[33],enable),
       (O[32],o_state[32],enable),
       (O[31],o_state[31],enable),
       (O[30],o_state[30],enable),
       (O[29],o_state[29],enable),
       (O[28],o_state[28],enable),
       (O[27],o_state[27],enable),
       (O[26],o_state[26],enable),
       (O[25],o_state[25],enable),
       (O[24],o_state[24],enable),
       (O[23],o_state[23],enable),
       (O[22],o_state[22],enable),
       (O[21],o_state[21],enable),
       (O[20],o_state[20],enable),
       (O[19],o_state[19],enable),
       (O[18],o_state[18],enable),
       (O[17],o_state[17],enable),
       (O[16],o_state[16],enable),
       (O[15],o_state[15],enable),
       (O[14],o_state[14],enable),
       (O[13],o_state[13],enable),
       (O[12],o_state[12],enable),
       (O[11],o_state[11],enable),
       (O[10],o_state[10],enable),
       (O[9],o_state[9],enable),
       (O[8],o_state[8],enable),
       (O[7],o_state[7],enable),
       (O[6],o_state[6],enable),
       (O[5],o_state[5],enable),
       (O[4],o_state[4],enable),
       (O[3],o_state[3],enable),
       (O[2],o_state[2],enable),
       (O[1],o_state[1],enable),
       (O[0],o_state[0],enable);
wire u_error;
wire blockIsSelected;
wire enable_sh;
wire enable_sh_in;

reg sh_a_error;
wire sh_a_error_in;
assign sh_a_error_in = sh_a_error;
reg sh_ck_error;
wire sh_ck_error_in;
assign sh_ck_error_in = sh_ck_error;
reg s_web_error;
wire s_web_error_in;
assign s_web_error_in = s_web_error;
reg h1_web_error;
wire h1_web_error_in;
assign h1_web_error_in = h1_web_error;
reg sh_ba_error;
wire sh_ba_error_in;
assign sh_ba_error_in = sh_ba_error;
wire sh_csb_error_in;
reg sh_csb_error;
assign sh_csb_error_in = sh_csb_error;
wire sh_is_error_in;
reg sh_is_error;
assign sh_is_error_in = sh_is_error;
wire sh_ih_error_in;
reg sh_ih_error;
assign sh_ih_error_in = sh_ih_error;
assign enable_sh = ~csb_state && blockIsSelected;
assign enable_sh_in = ~csb_state && blockIsSelected && ~web_state;

wire ck_del;
wire ck_d;
assign `mintimestep ck_d = ck_state;

spram512x50_cb_behave ram (a_state,ck_state,web_state,oeb_state,csb_state,
                    i_state,o_state,
                    enable,ck_d,blockIsSelected,sh_a_error_in,s_web_error_in,
                    h1_web_error_in,sh_ba_error_in,sh_ck_error_in,
                    sh_csb_error_in,sh_is_error_in,sh_ih_error_in
                    );

initial
begin
  sh_a_error    = 1'b0;
  s_web_error   = 1'b0;
  h1_web_error  = 1'b0;
  sh_ba_error  = 1'b0;
  sh_ck_error   = 1'b0;
  sh_csb_error  = 1'b0;
  sh_is_error   = 1'b0;
  sh_ih_error   = 1'b0;
end

`ifdef POLARIS_CBS

`else
always @(posedge sh_a_error)    sh_a_error    <= 1'b0;
always @(posedge s_web_error)   s_web_error   <= 1'b0;
always @(posedge h1_web_error)  h1_web_error  <= 1'b0;
always @(posedge sh_ba_error)  sh_ba_error  <= 1'b0;
always @(posedge sh_ck_error)   sh_ck_error   <= 1'b0;
always @(posedge sh_csb_error)  sh_csb_error  <= 1'b0;
always @(posedge sh_is_error)   sh_is_error   <= 1'b0;
always @(posedge sh_ih_error)   sh_ih_error   <= 1'b0;
`endif

specify
  specparam DF     = 1.0,
            tACC  = 2.06494*DF, // access time
            tCYC   = 2.51276*DF,   // cycle time
            tHCEB  = 1.03654*DF,  // minimum clock high time.
	    tLCEB  = 0.471797*DF,  // minimum clock low time.
            tWSr   = 0.079*DF,   // WEB rising setup time
            tWSf   = 0.123*DF,   // WEB falling setup time
            tIS    = 0.660156*DF,   // Data setup time
	    tWH    = 0.077*DF,    // WEB hold time
	    tAS    = 0.479353*DF,    // Address setup time
	    tAH    = 0*DF,    // Address hold time
	    tIH    = 0*DF,    // Data hold time
	    tCSf   = 1.03654*DF,    // CSB falling setup time
	    tCSr   = 0.119*DF,    // CSB rising setup time
	    tCH    = 0.004*DF,    // CSB hold time
	    tHOE   = 0.639959*DF,   // OEB disable time
	    tLOE   = 0.688744*DF,  // OEB enable time
	    tLBA   = 0.857282*DF,   // BA disable time
	    tHBA   = 0.805765*DF,  // BA enable time
	    tHW    = 0.599944*DF,    // WEB disable time
	    tLW    = 0.621771*DF,   // WEB enable time
            PATHPULSE$CEB$O = 0,
            PATHPULSE$OEB$O = 0;

   (CEB => O[0]) = (tACC,tACC);
   (OEB => O[0]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[1]) = (tACC,tACC);
   (OEB => O[1]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[2]) = (tACC,tACC);
   (OEB => O[2]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[3]) = (tACC,tACC);
   (OEB => O[3]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[4]) = (tACC,tACC);
   (OEB => O[4]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[5]) = (tACC,tACC);
   (OEB => O[5]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[6]) = (tACC,tACC);
   (OEB => O[6]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[7]) = (tACC,tACC);
   (OEB => O[7]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[8]) = (tACC,tACC);
   (OEB => O[8]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[9]) = (tACC,tACC);
   (OEB => O[9]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[10]) = (tACC,tACC);
   (OEB => O[10]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[11]) = (tACC,tACC);
   (OEB => O[11]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[12]) = (tACC,tACC);
   (OEB => O[12]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[13]) = (tACC,tACC);
   (OEB => O[13]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[14]) = (tACC,tACC);
   (OEB => O[14]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[15]) = (tACC,tACC);
   (OEB => O[15]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[16]) = (tACC,tACC);
   (OEB => O[16]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[17]) = (tACC,tACC);
   (OEB => O[17]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[18]) = (tACC,tACC);
   (OEB => O[18]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[19]) = (tACC,tACC);
   (OEB => O[19]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[20]) = (tACC,tACC);
   (OEB => O[20]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[21]) = (tACC,tACC);
   (OEB => O[21]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[22]) = (tACC,tACC);
   (OEB => O[22]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[23]) = (tACC,tACC);
   (OEB => O[23]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[24]) = (tACC,tACC);
   (OEB => O[24]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[25]) = (tACC,tACC);
   (OEB => O[25]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[26]) = (tACC,tACC);
   (OEB => O[26]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[27]) = (tACC,tACC);
   (OEB => O[27]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[28]) = (tACC,tACC);
   (OEB => O[28]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[29]) = (tACC,tACC);
   (OEB => O[29]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[30]) = (tACC,tACC);
   (OEB => O[30]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[31]) = (tACC,tACC);
   (OEB => O[31]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[32]) = (tACC,tACC);
   (OEB => O[32]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[33]) = (tACC,tACC);
   (OEB => O[33]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[34]) = (tACC,tACC);
   (OEB => O[34]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[35]) = (tACC,tACC);
   (OEB => O[35]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[36]) = (tACC,tACC);
   (OEB => O[36]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[37]) = (tACC,tACC);
   (OEB => O[37]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[38]) = (tACC,tACC);
   (OEB => O[38]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[39]) = (tACC,tACC);
   (OEB => O[39]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[40]) = (tACC,tACC);
   (OEB => O[40]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[41]) = (tACC,tACC);
   (OEB => O[41]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[42]) = (tACC,tACC);
   (OEB => O[42]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[43]) = (tACC,tACC);
   (OEB => O[43]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[44]) = (tACC,tACC);
   (OEB => O[44]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[45]) = (tACC,tACC);
   (OEB => O[45]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[46]) = (tACC,tACC);
   (OEB => O[46]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[47]) = (tACC,tACC);
   (OEB => O[47]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[48]) = (tACC,tACC);
   (OEB => O[48]) = (0,0,tHOE,tLOE,tHOE,tLOE);
   (CEB => O[49]) = (tACC,tACC);
   (OEB => O[49]) = (0,0,tHOE,tLOE,tHOE,tLOE);

  //--------------- Error checks ----------------------------------//
  $setup(negedge A[0],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[0],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[0],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[0],tAH,sh_a_error);  
  $setup(negedge A[1],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[1],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[1],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[1],tAH,sh_a_error);  
  $setup(negedge A[2],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[2],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[2],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[2],tAH,sh_a_error);  
  $setup(negedge A[3],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[3],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[3],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[3],tAH,sh_a_error);  
  $setup(negedge A[4],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[4],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[4],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[4],tAH,sh_a_error);  
  $setup(negedge A[5],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[5],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[5],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[5],tAH,sh_a_error);  
  $setup(negedge A[6],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[6],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[6],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[6],tAH,sh_a_error);  
  $setup(negedge A[7],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[7],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[7],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[7],tAH,sh_a_error);  
  $setup(negedge A[8],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $setup(posedge A[8],negedge CEB &&& enable_sh,tAS,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,negedge A[8],tAH,sh_a_error);  
  $hold(negedge CEB &&& enable_sh,posedge A[8],tAH,sh_a_error);  
  $setup(posedge CSB,negedge CEB &&& blockIsSelected,tCSr,sh_csb_error);  
  $setup(negedge CSB,negedge CEB &&& blockIsSelected,tCSf,sh_csb_error);  
  $hold(negedge CEB &&& blockIsSelected,posedge CSB,tCH,sh_csb_error);
  $hold(negedge CEB &&& blockIsSelected,negedge CSB,tCH,sh_csb_error);
  $setup(posedge WEB,negedge CEB &&& enable_sh,tWSr,s_web_error);  
  $setup(negedge WEB,negedge CEB &&& enable_sh,tWSf,s_web_error);  
  $hold(negedge CEB &&& enable_sh,posedge WEB,tWH,h1_web_error);
  $hold(negedge CEB &&& enable_sh,negedge WEB,tWH,h1_web_error);
  $setup(negedge I[0],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[0],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[0],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[0],tIH,sh_ih_error);  
  $setup(negedge I[1],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[1],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[1],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[1],tIH,sh_ih_error);  
  $setup(negedge I[2],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[2],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[2],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[2],tIH,sh_ih_error);  
  $setup(negedge I[3],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[3],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[3],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[3],tIH,sh_ih_error);  
  $setup(negedge I[4],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[4],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[4],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[4],tIH,sh_ih_error);  
  $setup(negedge I[5],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[5],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[5],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[5],tIH,sh_ih_error);  
  $setup(negedge I[6],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[6],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[6],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[6],tIH,sh_ih_error);  
  $setup(negedge I[7],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[7],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[7],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[7],tIH,sh_ih_error);  
  $setup(negedge I[8],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[8],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[8],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[8],tIH,sh_ih_error);  
  $setup(negedge I[9],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[9],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[9],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[9],tIH,sh_ih_error);  
  $setup(negedge I[10],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[10],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[10],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[10],tIH,sh_ih_error);  
  $setup(negedge I[11],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[11],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[11],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[11],tIH,sh_ih_error);  
  $setup(negedge I[12],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[12],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[12],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[12],tIH,sh_ih_error);  
  $setup(negedge I[13],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[13],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[13],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[13],tIH,sh_ih_error);  
  $setup(negedge I[14],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[14],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[14],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[14],tIH,sh_ih_error);  
  $setup(negedge I[15],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[15],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[15],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[15],tIH,sh_ih_error);  
  $setup(negedge I[16],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[16],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[16],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[16],tIH,sh_ih_error);  
  $setup(negedge I[17],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[17],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[17],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[17],tIH,sh_ih_error);  
  $setup(negedge I[18],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[18],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[18],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[18],tIH,sh_ih_error);  
  $setup(negedge I[19],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[19],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[19],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[19],tIH,sh_ih_error);  
  $setup(negedge I[20],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[20],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[20],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[20],tIH,sh_ih_error);  
  $setup(negedge I[21],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[21],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[21],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[21],tIH,sh_ih_error);  
  $setup(negedge I[22],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[22],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[22],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[22],tIH,sh_ih_error);  
  $setup(negedge I[23],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[23],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[23],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[23],tIH,sh_ih_error);  
  $setup(negedge I[24],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[24],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[24],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[24],tIH,sh_ih_error);  
  $setup(negedge I[25],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[25],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[25],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[25],tIH,sh_ih_error);  
  $setup(negedge I[26],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[26],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[26],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[26],tIH,sh_ih_error);  
  $setup(negedge I[27],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[27],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[27],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[27],tIH,sh_ih_error);  
  $setup(negedge I[28],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[28],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[28],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[28],tIH,sh_ih_error);  
  $setup(negedge I[29],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[29],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[29],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[29],tIH,sh_ih_error);  
  $setup(negedge I[30],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[30],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[30],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[30],tIH,sh_ih_error);  
  $setup(negedge I[31],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[31],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[31],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[31],tIH,sh_ih_error);  
  $setup(negedge I[32],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[32],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[32],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[32],tIH,sh_ih_error);  
  $setup(negedge I[33],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[33],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[33],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[33],tIH,sh_ih_error);  
  $setup(negedge I[34],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[34],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[34],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[34],tIH,sh_ih_error);  
  $setup(negedge I[35],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[35],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[35],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[35],tIH,sh_ih_error);  
  $setup(negedge I[36],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[36],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[36],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[36],tIH,sh_ih_error);  
  $setup(negedge I[37],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[37],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[37],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[37],tIH,sh_ih_error);  
  $setup(negedge I[38],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[38],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[38],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[38],tIH,sh_ih_error);  
  $setup(negedge I[39],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[39],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[39],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[39],tIH,sh_ih_error);  
  $setup(negedge I[40],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[40],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[40],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[40],tIH,sh_ih_error);  
  $setup(negedge I[41],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[41],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[41],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[41],tIH,sh_ih_error);  
  $setup(negedge I[42],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[42],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[42],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[42],tIH,sh_ih_error);  
  $setup(negedge I[43],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[43],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[43],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[43],tIH,sh_ih_error);  
  $setup(negedge I[44],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[44],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[44],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[44],tIH,sh_ih_error);  
  $setup(negedge I[45],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[45],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[45],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[45],tIH,sh_ih_error);  
  $setup(negedge I[46],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[46],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[46],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[46],tIH,sh_ih_error);  
  $setup(negedge I[47],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[47],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[47],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[47],tIH,sh_ih_error);  
  $setup(negedge I[48],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[48],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[48],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[48],tIH,sh_ih_error);  
  $setup(negedge I[49],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $setup(posedge I[49],negedge CEB &&& enable_sh_in,tIS,sh_is_error);  
  $hold(negedge CEB &&& enable_sh_in,negedge I[49],tIH,sh_ih_error);  
  $hold(negedge CEB &&& enable_sh_in,posedge I[49],tIH,sh_ih_error);  

  $width(posedge CEB &&& enable_sh,tHCEB,0,sh_ck_error);
  $width(negedge CEB &&& enable_sh,tLCEB,0,sh_ck_error);

  $period(negedge CEB &&& enable_sh,tCYC,sh_ck_error);

endspecify

endmodule
`endcelldefine

module spram512x50_cb_behave(a_state,ck_state,web_state,oeb_state,csb_state,
                    i_state,o_state,
                    ena_state,ck_delayed,blockIsSelected,sh_a_error,
                    s_web_error,h1_web_error,sh_ba_error,sh_ck_error,
                    sh_csb_error,sh_is_error,sh_ih_error
                    );

reg [`numOut-1:0] memory[`wordDepth-1:0];
reg [`numOut-1:0] int_bus;
reg [`numOut-1:0] tempbus;
input [`numAddr-1:0] a_state;
wire [`numAddr-1:0] a_state;
output ena_state;
reg enable;
assign ena_state = enable;
reg int_enable;
input ck_state,web_state,oeb_state,csb_state;
input [`numOut-1:0] i_state;
output [`numOut-1:0] o_state;
wire [`numOut-1:0] o_state, i_state;
assign o_state = int_bus;
output blockIsSelected;
reg blockIsSel;
assign blockIsSelected = blockIsSel;
reg csb_del;
integer address;
integer n;
wire u_error;
reg ih_error;
reg wenb_error;
input sh_ck_error;
input sh_a_error;
input s_web_error;
input h1_web_error;
input sh_ba_error;
input sh_csb_error;
input sh_is_error;
input sh_ih_error;
input ck_delayed;
event memoryError;

initial
begin : initialize
  ih_error = 0;
  wenb_error = 0;
  enable = 1'bx;
  int_enable = 1'bx;
  blockIsSel = 1'b1;
end

always @(memoryError)
begin
  if ((`verbose == 2 || `verbose == 3) && (web_state !== 1'b1 || ih_error === 1 || wenb_error !== 0))
  begin
    ih_error = 0;
    if (^a_state === 1'bx || ^a_state === 1'bz || sh_ba_error || sh_a_error || sh_ck_error || sh_csb_error || blockIsSel === 1'bx || ck_state === 1'bx || ck_state === 1'bz)
    begin
      wenb_error = 0;
      for (n=0; n < `wordDepth; n = n + 1)
        memory[n] = `numOut'bx;
    end
    else
    begin
      memory[address] = `numOut'bx;
    end
  end
end

task Warning;
  input [1024:1] msg;
  begin
  if ((`verbose == 1 || `verbose == 3) && csb_state !== 1'b1 && blockIsSel !== 1'b0)
    begin
      $display("%.1f : %m : %0s",$realtime,msg);
    end
  end
endtask

//----------------------------- look if block is selected ------------------


always @(blockIsSel or oeb_state or ck_state or csb_state)
begin : gen_enable
  if ((oeb_state === 1'bx || oeb_state === 1'bz) && web_state !== 1'b0 && blockIsSel !== 1'b0)  
  begin
    Warning("OEB is unknown.");
  end
  if ((ck_state === 1'bx || ck_state === 1'bz) && blockIsSel !== 1'b0 && web_state !== 1'b0 && oeb_state !== 1'b1)
  begin
    int_enable = 1'bx;
  end
  else
  begin
    int_enable = blockIsSel & ~oeb_state;
  end
end

//--------------------------- In-Active clock edge -------------------------
always @(posedge ck_state)
begin : check_ck_unk
  if ((ck_state === 1'bx || ck_state === 1'bz) && blockIsSel === 1'b1 && csb_state === 1'b0)
  begin
    Warning("CEB is unknown.");
    ->  memoryError;
  end
end

always @(csb_state) `mintimestep csb_del = csb_state;

//--------------------------- Active clock edge ---------------------------
always @(negedge ck_state) //ck_delayed if notovi
begin : ck_active_edge  
  if ((web_state === 1'bx || web_state === 1'bz) && blockIsSel === 1'b1 && oeb_state === 1'b1)
  begin
    Warning("WEB is unknown.");
    ->  memoryError;
  end
  if ((ck_state === 1'bx || ck_state === 1'bz) && blockIsSel === 1'b1 && csb_state === 1'b0)
  begin
    Warning("CEB is unknown.");
    ->  memoryError;
  end
  if ((csb_state === 1'bx || csb_state === 1'bz) && ((web_state === 1'b1))) 
  begin
    Warning("CSB is unknown.");
    ->  memoryError;
  end
  if (a_state >= `wordDepth)
  begin
    Warning("Address is out of range - cannot access memory.");
  end
  if (^a_state === 1'bx || ^a_state === 1'bz)
  begin
    Warning("Address is unknown - cannot access memory.");
    ->  memoryError;
    if (`verbose == 2 || `verbose == 3)
    begin
      address = -1;
    end
  end
  else  address = a_state;
  if (blockIsSel === 1'b1 && csb_del === 1'b0)
  begin
    if (web_state === 1'b0) //-------- Write
    begin
      if (^i_state === 1'bx || ^i_state === 1'bz)
      begin
//        Warning("Data Input unknown during write");
      end
      memory[address] = i_state;
    end
    else if (web_state === 1'b1) //-------- READ
    begin
      int_bus = memory[address];
    end
    else
    begin
      Warning("WEB is unknown.");
      if (`verbose == 2 || `verbose == 3)
      begin
        int_bus = `numOut'bx;
      end
      -> memoryError;
    end
  end
end

always @(int_enable)
begin : output_data_en
  if (`verbose == 2 || `verbose == 3)
  begin
    enable = int_enable;
  end
  else
  begin
    if (int_enable !== 1'b0) enable = 1'b1;
    else                     enable = int_enable;
  end
end

`ifdef POLARIS_CBS

`else
always @(sh_ck_error or sh_csb_error or sh_a_error)
begin : setup_ck_error
  if (web_state !== 1'b0 && (`verbose == 2 || `verbose == 3)) 
  begin
    int_bus = `numOut'bx;
  end
  ->  memoryError;
end

always @(sh_ba_error)
begin : setup_ba_error
  int_bus = `numOut'bx;
  ->  memoryError;
end

always @(h1_web_error or s_web_error)
begin : setup_h1_error
  ih_error = 1;
  if (`verbose == 2 || `verbose == 3)
  begin
    int_bus = `numOut'bx;
  end
  ->  memoryError;
end

always @(sh_ih_error or sh_is_error)
begin : setup_ih_error
  ih_error = 1;
  ->  memoryError;
end

`endif

endmodule

`undef numAddr
`undef numOut
`undef wordDepth
`undef verbose
`undef mintimestep
