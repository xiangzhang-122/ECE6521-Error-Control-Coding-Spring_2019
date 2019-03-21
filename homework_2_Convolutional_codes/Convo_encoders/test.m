% 1.
 u= [1 0 1 1 1 0 1 0 0 1 1 0];
%  miu =7;
%  gen_poly=[117, 155];
%  [v1,v2] = NR_encoder(u, miu, gen_poly)
 
% 2(a)
%  miu =2;
%  gen_poly=[3 ,1];
%  fb_poly = 3;
%  [v1,v2] = SR_encoder(u, miu, gen_poly, fb_poly)
% 2(b)
 miu =5;
 gen_poly=[37, 21];
 fb_poly = 37;
 [v1,v2] = SR_encoder(u, miu, gen_poly, fb_poly)