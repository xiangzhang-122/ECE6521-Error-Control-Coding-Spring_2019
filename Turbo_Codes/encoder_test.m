
% u =[  1 0 0 1 0 0 1 1 1 0 1 0 1 1 0 1 ];   % code check sequence
u =[  1 0 0 1 0 0 1 1 1 0 1 0 1 1 0 1 ];
miu=5 ;
gen_poly=[37,21];
fb_poly=37;
[code_1, v_01,v_11,v_21] = turbo_encoder(u, miu, gen_poly, fb_poly, 'punc');
[code_2, v_02,v_12,v_22] = turbo_encoder(u, miu, gen_poly, fb_poly, 'non_punc');
code_1
code_2
[r_0, r_1,r_2]=extract(code_1, 'punc')
[r_00, r_11,r_22]=extract(code_2, 'non_punc')
r_0 == v_01
r_1 == v_11
r_2== v_11

