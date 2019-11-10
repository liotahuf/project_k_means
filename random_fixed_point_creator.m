%% project divider test
rand_num =-2 + 4*rand;
fixed_point_rand = fi(rand_num,1,22,10) 
bin(fixed_point_rand)
cnt = randi(20);
div = rand_num/cnt;
div_fixed = fi(div,1,22,10) 
bin(div_fixed)