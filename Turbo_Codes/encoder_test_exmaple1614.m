
% u =[  1 0 0 1 0 0 1 1 1 0 1 0 1 1 0 1 ];   % code check sequence
u =[0 1 0 ];
miu=2 ;
gen_poly=[3,2];
fb_poly=3;
[code_1, v_01,v_11,v_21] = turbo_encoder(u, miu, gen_poly, fb_poly, 'punc');
[code_2, v_02,v_12,v_22] = turbo_encoder(u, miu, gen_poly, fb_poly, 'non_punc');
code_1
code_2
% [r_0, r_1,r_2]=extract(code_1, 'punc')
[r_00, r_11,r_22]=extract(code_2, 'non_punc')
r_00 == v_02
r_11 == v_12
r_22== v_22
