
format long
%% -------------  turbo code generation ------------------------------------
Len_info = 6;
info_seq = round(rand(1, Len_info));  % info sequence
miu = 3;
gen_poly = [7,5];
fb_poly = 7;
trellis = poly2trellis(miu, gen_poly, fb_poly);
punc_flag = 'punc';
rate = 0.5;
[code,v_0,v_1,v_2, ~,~] = turbo_encoder(info_seq, miu, gen_poly, fb_poly, punc_flag);
% [code,v_0,v_1,v_2, rand_perm,last_state_2] = turbo_encoder(u, miu,
% gen_poly, fb_poly, punc_flag); % syntax
code_len = length(code);
% %% ============================= test case 3===============================
% rand_perm_turbo =[ 2 1 7 5 3 6 8 4];
% rand_perm_ch = [ 3 8 14  1 5 4 10 9 11 16 15 12 13 6 7 2];
% H_all = zeros(2,2,4);
% H_all(:,:,1) = [-0.9+2i, 0.2+2i;  -0.3-1i, 2.5+0.5i];
% H_all(:,:,2) = [1i, -0.1+1i; 0.5+1i,0.5i];
% H_all(:,:,3) = [-0.9+0.7i, 1-0.2i; 0.5+0.5i,0.3+0.2i];
% H_all(:,:,4) = [-0.6-0.5i, -0.8+1i; 0.6-2i,-0.7+0.2i ];
% r_seq =[1+1.5i, 2-0.2i, -2+1i,-0.6+1.4i, 0.6-0.2i,1.3-0.5i, -1+0.8i, -1-0.4i  ].';
%% ================================ test case 4 ===========================
rand_perm_turbo =[ 3 6 8 4 2 1 7 5 ];
rand_perm_ch = [ 11 16 15 12 13 6 7 2 3 8 14  1 5 4 10 9];
H_all = zeros(2,2,4);
H_all(:,:,1) = [-0.9-2i, 0.2-2i;  -0.3-1i, 2.5+0.5i];
H_all(:,:,2) = [-1i, -0.1-1i; 0.5+1i,0.5i];
H_all(:,:,3) = [-0.9-0.7i, 1+0.2i; 0.5+0.5i,0.3+0.2i];
H_all(:,:,4) = [-0.6+0.5i, -0.8-1i; 0.6-2i,-0.7+0.2i ];
r_seq =[1+1.5i, 2+0.2i, -2+1i,-0.6-1.4i, 0.6-0.2i,1.3+0.5i, -1+0.8i, -1+0.4i  ].';
%% ========================================================================
N_iter_mimo = 4;  %  mimo detection # iterations
N_iter_dec = 8;  % turbo ddecoding # of iterations
LA_mat = zeros(4,4);    % initialization


% ------------------------ outer loops ---------------------------------
for ii = 1: N_iter_mimo
    lde_mat = mimo_detect_all(LA_mat, H_all, r_seq, 4); % 2dB, ld_matt: num_channel_use * 4
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
    end
    %%
    ex_LLR_p1 = LLR_p1 - ld_p1;
    ex_LLR_p2 = LLR_p2 - ld_p2;
    ex_LLR_u_12 = LLR_u_2 - perm(ld_u, rand_perm_turbo);
    ex_LLR_u_12 = de_perm(ex_LLR_u_12, rand_perm_turbo);
    LA_vec = code_compo_combine(ex_LLR_u_12, ex_LLR_p1, ex_LLR_p2 );
    LA_vec = perm(LA_vec, rand_perm_ch);
    LA_mat = de_stretch(LA_vec, 4);     % fold vector into matrix
end  









    




