% Mar. 20 code check
% remaining issues: unterminated code;
%                   entire code check of Turbo;

% %------------------- test case 1 ----------------------------------
% gen_poly= [7,5];
% fb =  7; 
% rate = 0.5;
% miu = 3;% m =2
% trellis = poly2trellis(miu, gen_poly, fb);
% ap_LLR=[2,-1, 0,0.5, -0.7];  % test case 1
% y=[ 0.8, -0.6, 1.2, -0.5, 2, -1, -1.5, 2.0, 1.3, -0.7]; 
% term_flag = 'non_term';
% snr = 0.2 ;% snr= E_s/N_0
% [alpha, beta, LLR, dec_seq] = mogen_log_map_bcjr(y, trellis, snr, ap_LLR, term_flag)
%% llr for terminated case: 
%2.573663052047697  -1.380723254418929   2.477726489316956  -1.989693065082067   1.264966821650841
%% unterminated llr:
% 2.258927904067340  -0.343284364945843   1.368686809061400  -0.948310308016058   0.227569412059787

 

%%--------------- test case  2   ---------------------
gen_poly= [27, 31];
fb= 27;
rate = 0.5;
miu = 5;
trellis = poly2trellis(miu, gen_poly,fb);
ap_LLR =[ 0, 1 ,-0.5, 0.8, 0.4,  -0.8, 0.6, 1, 1.2, -1.4]; 
y =[0.6,-0.3,0.2, 0.7,0.2, 0.6,-0.4,-0.5,0.3,-0.1,-0.8,-0.4,-0.7,0.5,0.4,0.3,0.8,1,-1.2,-1.4];
term_flag = 'non_term';
snr =  0.4;    
[alpha, beta, LLR, dec_seq] = mogen_log_map_bcjr(y, trellis, snr, ap_LLR, term_flag)
%%---------------------------------------------------------------
% correct llr for terminated case:
%Columns 1 through 7
% 
%   -0.315076474348334   1.287935839495797   0.387721368949848   0.493509611269893   0.940139988103629  -1.693392888498957  -1.027966011009353
% 
%   Columns 8 through 10
% 
%    0.874350781456030   3.532801810570763  -5.678392118627356






