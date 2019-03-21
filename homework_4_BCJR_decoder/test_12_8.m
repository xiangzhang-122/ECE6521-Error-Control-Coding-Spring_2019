% example 12.8   verification 
gen_poly= [3,2];
rate =0.5;
fb_poly = 3;
miu = 2;
trellis = poly2trellis(miu, gen_poly, fb_poly);
y= [0.8,0.1, 1, -0.5,-1.8,1.1, 1.6,-1.6];
% [log_alpha, log_beta, LLR, dec_seq] = log_map_bcjr(y, trellis, 0.25);
ap_LLR = zeros(1,rate*length(y));   % no priori
[alpha, beta, LLR, dec_seq] = mogen_log_map_bcjr(y, trellis, 0.25, ap_LLR, 'term')


%%%% results %%%%%%%

% alpha =
% 
%                    0                   0
%   -0.450000000000000   0.450000000000000
%    1.339386758282961   0.444396660073571
%    1.754746551991426   2.234104997321040
%    3.951897266246221   2.036966636480407
% 
% 
% beta =
% 
%    3.951897266246222   4.073436977073144
%    3.441612441527087   3.019361283453850
%    1.591153874732088   3.061047744848594
%                    0   1.600000000000000
%                    0                   0
% 
% 
% LLR =
% 
%    0.477748841926763   0.615455270332635  -1.030187711484352   2.079358445329615
% 
% 
% dec_seq =
% 
%      1     1     0     1



