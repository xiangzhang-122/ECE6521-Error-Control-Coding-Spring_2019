% miu = m+1
% ap_llr is the a priori which is zero for the first iteration
% Num_iter : # of iterations
% punc_flag ='punc'/'non_punc', indicates the code is punctured or not
% rand_perm : random permutation used in the encoder, h+m bits in length
% term_flag_1 ='term'/'non_term'-> whether ENC1 is terminated (actually always terminated)
% term_flag_2 ='term'/'non_term'-> whether ENC2 is terminated (uausally not terminated)
% SNR refers to E_b/N_0
function [dec_seq, app_LLR]= turbo_decoder(recv_seq, miu, gen_poly, fb_poly, SNR, ap_llr, rand_perm, Num_iter, punc_flag, term_flag_1, term_flag_2 )
% len =length(recv_seq);
% numeric SNR = E_b/N_0, not in dB
rate_recp = 0;
if strcmp(punc_flag, 'punc')
    rate_recp = 2;
else 
    rate_recp = 3;
end
L_c = 4*SNR/rate_recp;  % channel realiablilty parameter
[r_0,r_1,r_2] = extract(recv_seq, punc_flag);  % extract the component codes
% when punctured, r_1 and r_2 do not equal the original parity check
% sequence, only equal at odd indices for r-1 and even indices for r_2
recv_seq_1 = combine(r_0,r_1);
perm_r_0 = perm(r_0, rand_perm);
recv_seq_2 = combine(perm_r_0 , r_2);   % permutated sequence
ex_LLR_2 = ap_llr; % this intialzted as all zero
dec_seq=zeros(1, length(r_0));
app_LLR = zeros(1, length(r_0));
trellis = poly2trellis(miu, gen_poly, fb_poly);
cnt =0;
for i=1:Num_iter   
    [~, ~, LLR_1, ~] = mogen_log_map_bcjr( recv_seq_1, trellis, SNR/rate_recp, ex_LLR_2 , term_flag_1);
    ex_LLR_1 = LLR_1 - ex_LLR_2 - L_c*r_0;
    ex_LLR_1 = perm(ex_LLR_1, rand_perm);
    [~,~, LLR_2, ~] = mogen_log_map_bcjr( recv_seq_2, trellis, SNR/rate_recp, ex_LLR_1, term_flag_2 );
    ex_LLR_2 = LLR_2 - ex_LLR_1- L_c*perm(r_0, rand_perm) ;
    ex_LLR_2 = de_perm(ex_LLR_2, rand_perm);
    cnt=cnt+1
end
app_LLR = de_perm(LLR_2, rand_perm);  % normal order
% app_LLR_1 =perm(LLR_2, rand_perm);
for i =1:length(r_0)
    if app_LLR(i)>0
        dec_seq(i) = 1;
    else 
        dec_seq(i) = 0;
    end
end
end %func