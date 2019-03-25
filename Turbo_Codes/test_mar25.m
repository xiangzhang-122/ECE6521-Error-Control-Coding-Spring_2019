
gen_poly =[37,21];
fb_poly = 37; 
miu  = 5;
recv_seq =[2 ,-0.5,1,0.9, 1.2, -0.8, -1, -0.3, -0.5, 1.6, -0.8,2, -0.9, -1.3, 0.6, 1.2, -1.6, 0.5, -1.4,-1.6, 0.3,1.6,-0.2,2.5,-3.2, 2, -1.4, 0.7,2.2, -1.2, 2, -1.3, 1.6, -0.4, -1.6, 1.8,-1.8,-2.5,1.1,-2 ];
SNR = 10^(3/10);
ap_llr = zeros(1,20);
rand_perm=[ 5,7,16, 4,1,19,10, 15,3,20,12,8,14,2,17,11,18,6,13,9];
punc_flag ='punc';
Num_iter = 10;
term_flag_1 ='term';
term_flag_2 ='non_term';
[dec_seq, app_LLR] = turbo_decoder(recv_seq, miu, gen_poly, fb_poly, SNR, ap_llr, rand_perm, Num_iter, punc_flag, term_flag_1, term_flag_2 )
a = perm(app_LLR, rand_perm)