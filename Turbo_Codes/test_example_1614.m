% test file
recv_seq = [0.8,0.1,-1.2 ,  1.0, -0.5, 1.2, -1.8, 1.1, 0.2, 1.6, -1.6, -1.1];
% recv_seq = [ -1  -1 -1 1 1 1 -1 1 -1 1 -1 -1 ] + randn(1,12)/sqrt(3);
miu= 2;
gen_poly =[3,2];
fb_poly =3;
SNR = 0.75;   % refers to E_b/N_0;
% for non_puncturing codes, this SNR leads to L_c =1
ap_llr = zeros(1,4);
rand_perm =[0 2 1 3 ]+1;
Num_iter =1;
punc_flag ='non_punc';
term_flag_1 ='term';
term_flag_2 ='term';
[dec_seq, app_LLR]= turbo_decoder(recv_seq, miu, gen_poly, fb_poly, SNR, ap_llr, rand_perm, Num_iter, punc_flag,term_flag_1,term_flag_2 )
% argument SNR refers to E_b/N_0 =0.75 --> L_c = 1 if not punctured (rate =1/3)