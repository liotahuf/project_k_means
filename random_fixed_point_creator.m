%% project divider test
rand_num =-2 + 4*rand;
fixed_point_rand = fi(rand_num,1,22,10) 
bin(fixed_point_rand)
cnt = randi(20);
div = rand_num/cnt;
div_fixed = fi(div,1,22,10) 
bin(div_fixed)

rand_num =-2 + 4*rand;
fixed_point_rand = fi(-1223,1,22,10) 
bin(fixed_point_rand)
cnt = 390;
div = fixed_point_rand/cnt;
div_fixed = fi(div,1,22,10) 
bin(div_fixed)

%% convergence check fixed point creator
rand_num =-2 + 4*rand;
fixed_point_rand = fi(rand_num,1,22,10); 
bin(fixed_point_rand);
