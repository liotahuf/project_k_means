tic
D =0xB;
D =D+0xC;
D =D+0xD;
D =D+0xE;
D =D+0xF;
D =D+0x10;
D =D+0x11;
D =D+0x12;

expected_accum = sum([11:1:18]);
expected_res = expected_accum/8;
expected_res_bin = dec2bin(expected_res,13);
expected_fixed_point_res = q2dec(expected_fixed_point_res_bin,2,10,'bin');
expected_hex_res = bin2hex(expected_fixed_point_res_bin);

our_res_dec =idivide(D,8);
our_res_dec_bin = dec2bin(our_res_dec,13);
our_res_dec_fixed_point= q2dec(our_res_dec_bin,2,10,'bin');
expected_hex_res = bin2hex(our_res_dec_bin);

%% ressult if this was done with doubles

double_accum = sum([11:1:18]);
double_res = double_accum/8;
double_res_fixe_point =double_res/1024;

%% runnig k means in matlab for input data
tic
X = zeros (10,7);

for i=11:1:18
    a = i;
    a = dec2bin(a,13);
    X(i-10,7)= q2dec(a,2,10,'bin');
end

X(9,6) = q2dec(dec2bin(7,13),2,10,'bin');

X(10,7) = q2dec(dec2bin(7,13),2,10,'bin');
X(10,5) = q2dec(dec2bin(17,13),2,10,'bin');

C = zeros (8,7);

for i=1:1:8
    a = i;
    a = dec2bin(a,13);
    C(i,7)= q2dec(a,2,10,'bin');
end
[idx,R] = kmeans(X,[],'Display','iter','EmptyAction','drop','Distance','cityblock','start',C);

R_round =round(R,4);
toc

%% actual results conversion
cent_1 = 0xE000
cent_1_bin  = dec2bin(cent_1,26);
cent_1_dim_2_bin = cent_1_bin(1:end-13);
cent_1_dim_2__res = q2dec(cent_1_dim_2_bin,2,10,'bin');

cent_7 = 0x44000007;
cent_7_bin  = dec2bin(cent_7,3*13);
cent_7_dim_3_bin = cent_7_bin(1:end-13-13);
cent_7_dim_1_bin = cent_7_bin(end-12:end);
cent_7_dim_3_res = q2dec(cent_7_dim_3_bin,2,10,'bin');
cent_7_dim_1_res = q2dec(cent_7_dim_1_bin,2,10,'bin');

cent_8 =0x0E
cent_8_bin  = dec2bin(cent_8,13);
cent_8_dim_1_bin = cent_8_bin(end-12:end);
cent_8_dim_1_res = q2dec(cent_8_dim_1_bin,2,10,'bin');


toc


