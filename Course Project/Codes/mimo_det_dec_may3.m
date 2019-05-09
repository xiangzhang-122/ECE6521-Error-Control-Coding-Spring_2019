
% =============== Joint MIMO Detection & Decoding ========================
% H_all : num_block by 4 channel matrix
% LA_mat : num_block by 4 prior
%  rand_perm_turbo, rand_perm_ch-- channel/turbo interleaver
% this code is used for code check and thus is modified and different from
% the original function 'mimo_det_dec.m'.
function [decoded_seq, llr] = mimo_det_dec_may3( info_sequence,r_seq, H_all, LA_mat,N_iter_mimo, N_iter_dec, rand_perm_turbo, rand_perm_ch, trellis, bit_snr_db )
format long
% ------------------------ outer loops ---------------------------------
for ii = 1: N_iter_mimo
    lde_mat = mimo_detect_all(LA_mat, H_all, r_seq, bit_snr_db); % 2dB, ld_matt: num_channel_use * 4
    lde_vec = stretch (lde_mat);  % , ex llr; matrix into row vector by concatenating rows of ld_mat
    lde_vec_1 = de_perm(lde_vec, rand_perm_ch); % channel deperm
    [ld_u, ld_p1, ld_p2] = code_compo_extract(lde_vec_1, 'punc'); 
    ex_LLR_u_2 = zeros(1, length(ld_u));
    cnt = 0;
    %% ------------------------ inner loops ------------------------------
    for jj = 1: N_iter_dec
        [~, ~, LLR_u_1, LLR_p1, ~] = bcjr_with_parity_llr(trellis, ex_LLR_u_2, ld_u, ld_p1, 'term' );
        ex_LLR_u_1 = LLR_u_1 - ex_LLR_u_2 - ld_u; %
        ex_LLR_u_1 = perm(ex_LLR_u_1, rand_perm_turbo);   % interlv turbo
        tt = perm(ld_u, rand_perm_turbo);
        [~, ~, LLR_u_2, LLR_p2, ~] = bcjr_with_parity_llr(trellis, ex_LLR_u_1,tt, ld_p2,'non_term' );
        gg = de_perm(LLR_u_2, rand_perm_turbo);    % Soft L outputs, combine(gg, LLR_p1,LLR_p2)
        ex_LLR_u_2 = LLR_u_2 - ex_LLR_u_1 - perm(ld_u, rand_perm_turbo) ;% latter part is not useful actually
        ex_LLR_u_2 = de_perm(ex_LLR_u_2, rand_perm_turbo);  
        cnt = cnt + 1;
%   The following snippet is used to out the error for each inner and outer
%   iteration
        llr_temp = de_perm(LLR_u_2, rand_perm_turbo);
        dec_temp = decision(llr_temp);
        err_temp = error_compute(dec_temp(1:length(info_sequence)), info_sequence);
        s = sprintf(' error =%d, turbo index= %d, outer index=%d', err_temp, jj,ii);
        display(s) ;
    end
    ex_LLR_p1 = LLR_p1 - ld_p1;
    ex_LLR_p2 = LLR_p2 - ld_p2;
    ex_LLR_u_12 = LLR_u_2 - perm(ld_u, rand_perm_turbo);
    ex_LLR_u_12 = de_perm(ex_LLR_u_12, rand_perm_turbo);
    LA_vec = code_compo_combine(ex_LLR_u_12, ex_LLR_p1, ex_LLR_p2 );
    LA_vec = perm(LA_vec, rand_perm_ch);
    LA_mat = de_stretch(LA_vec, 4);     % fold vector into matrix
end  

llr = de_perm(LLR_u_2, rand_perm_turbo);
decoded_seq = [];
for i = 1: length(llr)
    if llr(i) >=0
        decoded_seq(i) = 1;
    else
       decoded_seq(i) = 0;
    end
end
end
 







    




